//
//  MusicViewController.h
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"



@interface MusicViewController : UIViewController

@property (nonatomic, strong) MusicInfo *musicInfo; // 歌曲信息


@property (nonatomic, assign) NSInteger index;

@end