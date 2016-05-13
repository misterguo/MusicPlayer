//
//  MusicInfoHandle.h
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"

@interface MusicInfoHandle : NSObject

@property (nonatomic, strong) NSMutableArray *musicInfos;


/**
 *  单例
 *  @return
 */

+ (MusicInfoHandle *)shareHandle;

/**
 *  获取音乐信息
 *  @param url
 *  @param completion
 */
- (void)getMusicInfoWithUrl:(NSString *)url completion:(void(^)(NSArray *musicInfos, NSError *error))completion;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;
/**
 *  返回每个row对应的MusicInfo
 */
- (MusicInfo *)MusicInfoForRowAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)MusicCount;
- (MusicInfo *)MusicInfoWithIndex:(NSInteger)index;



@end
