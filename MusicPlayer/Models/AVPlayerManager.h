//
//  AVPlayerManager.h
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol  AVPlayerManagerDelegate <NSObject>
// 播放时间改变
- (void)changTime:(CGFloat)time;
// 播放完成
- (void)playDidFinish;

@end

typedef NS_ENUM(NSUInteger, AVPlayerManagerStatus) {
    AVPlayerPlaying, // 正在播放
    AVPlayerPauser, // 暂停
    AVPlayerStop,  // 停止播放
};

@interface AVPlayerManager : NSObject

@property (nonatomic, readonly) AVPlayerManagerStatus status; // 播放状态

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) CGFloat currentTime; // 当前的Item播放时间 单位second
@property (nonatomic, weak) id<AVPlayerManagerDelegate> delegate; // 代理

@property (nonatomic, strong) UIViewController *playVC; // 播放的ViewController


/**
 *  单例
 *  @return AVPlayerManager
 */
+ (AVPlayerManager *)shareManager;

/**
 *  加载播放
 */

- (void)playerWithUrl:(NSString *)url;
/**
 * 播放
 */

- (void)play;
/**
 *  暂停
 */

- (void)pause;

- (CGFloat)currentTime;

/**
 *  根据时间播放歌曲
 *  @param time
 */

- (void)seekToTime:(CGFloat)time;

- (void)setVolume:(CGFloat)volume;

@end
