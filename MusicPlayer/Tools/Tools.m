//
//  Tools.m
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/12.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "Tools.h"

@implementation Tools

/**
 *  将时长单位转化成时间格式字符串
 *  @param secinds
 *  return NSString
 */

+ (NSString *)timeStrFromSeconds:(CGFloat)seconds
{
    NSInteger sec = (NSInteger)seconds;
    NSInteger minute = sec / 60;
    NSString *minuteStr = [NSString stringWithFormat:@"%02ld", minute];
    NSInteger second = sec % 60;
    NSString *secondStr = [NSString stringWithFormat:@"%02ld", second];
    
    return [NSString stringWithFormat:@"%@:%@", minuteStr, secondStr];
}

@end
