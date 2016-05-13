//
//  MusicInfo.m
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "MusicInfo.h"

@implementation MusicInfo

@synthesize Id = _id;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (CGFloat)totalTime
{
    return _duration / 1000.0;
}

@end
