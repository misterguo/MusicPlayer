//
//  LyricHandle.m
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/13.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "LyricHandle.h"
#import "LyricModel.h"

@interface LyricHandle ()

@property (nonatomic, strong) NSMutableArray *lyricItemArray;

@property (nonatomic, assign) NSInteger index;

@end

static LyricHandle *lyricHandle = nil;

@implementation LyricHandle

+ (LyricHandle *)shareHandle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!lyricHandle) {
            lyricHandle = [[LyricHandle alloc] init];
        }
    });
    return lyricHandle;
}

- (void)changLyricString:(NSString *)string
{
    // 初始化数据源数组
    self.lyricItemArray = [NSMutableArray array];
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    for (NSString *str in array) {
        if (str.length == 0) {
            LyricModel *item = [LyricModel lyricWithLyricString:@"" Time:3000];
            [self.lyricItemArray addObject:item];
        } else {
            NSArray *arr = [str componentsSeparatedByString:@"]"];
            if (arr.count > 1) {
                NSString *timeString = [arr[0] substringFromIndex:1];
                NSString *lyricString = arr[1];
                NSArray *timeArray = [timeString componentsSeparatedByString:@":"];
                if (timeArray.count > 1) {
                    float minute = [timeArray[0] floatValue];
                    float second = [timeArray[1] floatValue];
                    float time = minute * 60 + second;
                    LyricModel *model = [LyricModel lyricWithLyricString:lyricString Time:time];
                    [self.lyricItemArray addObject:model];
                }
            } else {
                
            }
        }
    }
}

- (NSInteger)lyricItemCount
{
    return self.lyricItemArray.count;
}

- (NSString *)lyricStringWithIndex:(NSInteger)index
{
    LyricModel *model = self.lyricItemArray[index];
    return model.lyricString;
}

- (NSInteger)lyricItemWithTime:(float)time
{
    for (int i = 0; i < self.lyricItemArray.count; i++) {
        LyricModel *model = self.lyricItemArray[i];
        if (time < model.time) {
            _index = i - 1 > 0 ? i - 1 : 0;
            break;
        }
    }
    return _index;
}
@end
