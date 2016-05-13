//
//  LyricModel.m
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/13.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

- (id)initWithLyric:(NSString *)lyric Time:(float)time
{
    self = [super init];
    if (self) {
        _lyricString = lyric;
        _time = time;
    }
    return self;
}


+ (id)lyricWithLyricString:(NSString *)lyric Time:(float)time
{
    return [[LyricModel alloc] initWithLyric:lyric Time:time];
}

@end
