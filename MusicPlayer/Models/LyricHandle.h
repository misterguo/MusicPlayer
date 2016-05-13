//
//  LyricHandle.h
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/13.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricHandle : NSObject

+ (LyricHandle *)shareHandle;

- (void)changLyricString:(NSString *)string;

- (NSInteger)lyricItemCount;

- (NSString *)lyricStringWithIndex:(NSInteger)index;

- (NSInteger)lyricItemWithTime:(float)time;


@end
