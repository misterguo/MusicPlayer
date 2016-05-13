//
//  MusicInfoHandle.m
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "MusicInfoHandle.h"


static MusicInfoHandle *musicInfoHandle = nil;

@implementation MusicInfoHandle

/**
 *  单例
 *  @return
 */

+ (MusicInfoHandle *)shareHandle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!musicInfoHandle) {
            musicInfoHandle = [[MusicInfoHandle alloc] init];
        }
    });
    return musicInfoHandle;
}

/**
 *  获取音乐信息
 *  @param url
 *  @param completion
 */
- (void)getMusicInfoWithUrl:(NSString *)url completion:(void(^)(NSArray *musicInfos, NSError *error))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSError *resultError = error;
        if (!resultError) { // 判断数据请求是否成功
            // 生成plist文件路径
                NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"result.plist"];
            // 将请求的数据写入文件
                [data writeToFile:filePath options:NSDataWritingAtomic error:&resultError];
        if (!resultError) { // 判断数据写入文件是否成功
            // 用数组读取文件中的数据
        NSArray *resultArray = [NSArray arrayWithContentsOfFile:filePath];
            // 清空数组中所有的值, 便于重新加载数据
        [self.musicInfos removeAllObjects];
            // 将数组中的数据生成model
           for (NSDictionary *dic in resultArray) {
         MusicInfo *musicInfo = [[MusicInfo alloc] init];
         [musicInfo setValuesForKeysWithDictionary:dic];
         [_musicInfos addObject:musicInfo];
//         将歌单排序相反
//        [_musicInfos insertObject:musicInfo atIndex:0];
                    }
        } else {
                    resultError = [NSError errorWithDomain:@"数据写入文件失败" code:0 userInfo:@{@"requestType":@"MusicInfoGet"}];
                    NSLog(@"%@", resultError);
            }
                
            } else {
                NSLog(@"%@", resultError);
            }
            // block 回调
            if (completion) {
                completion(_musicInfos, resultError);
            }
        });
    }];
    [task resume];
}

- (NSMutableArray *)musicInfos
{
    if (!_musicInfos) {
        _musicInfos = [[NSMutableArray alloc] init];
    }
    return _musicInfos;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return _musicInfos.count;
}
/**
 *  返回每个row对应的MusicInfo
 */
- (MusicInfo *)MusicInfoForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _musicInfos[indexPath.row];
}

- (NSInteger)MusicCount
{
    return _musicInfos.count;
}

- (MusicInfo *)MusicInfoWithIndex:(NSInteger)index
{
    return _musicInfos[index];
}


@end
