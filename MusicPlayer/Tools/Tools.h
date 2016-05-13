//
//  Tools.h
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/12.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tools : NSObject

/**
 *  将时长单位转化成时间格式字符串
 *  @param secinds
 *  return NSString
 */

+ (NSString *)timeStrFromSeconds:(CGFloat)seconds;



@end
