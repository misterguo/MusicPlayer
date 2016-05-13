//
//  LyricModel.h
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/13.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject

@property (nonatomic, copy) NSString *lyricString;

@property (nonatomic) float time;

+ (id)lyricWithLyricString:(NSString *)lyric Time:(float)time;

@end
