//
//  MusicCell.h
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"

@interface MusicCell : UITableViewCell

/**
 *  为cell赋值
 *  @param musicInfo
 */

- (void)setValueWithMusicInfo:(MusicInfo *)musicInfo;

@end
