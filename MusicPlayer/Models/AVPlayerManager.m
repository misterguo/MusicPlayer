//
//  AVPlayerManager.m
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "AVPlayerManager.h"

static AVPlayerManager *avPlayerManager = nil;

@interface AVPlayerManager ()

@property (nonatomic, strong) AVPlayer *avPlayer; // 播放器

@property (nonatomic, strong) NSString *currentUrl; // 正在播放的url

@end

@implementation AVPlayerManager

/**
 *  单例
 *  @return AVPlayerManager
 */
+ (AVPlayerManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!avPlayerManager) {
            avPlayerManager = [[AVPlayerManager alloc] init];
        }
    });
    return avPlayerManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _status = AVPlayerStop;
        // 计时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        // 暂停
        _timer.fireDate = [NSDate distantFuture];
        // 添加歌曲播放完成通知监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerDidFinishPlay:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
/**
 *  接受到歌曲播放完成通知
 */
- (void)avPlayerDidFinishPlay:(NSNotification *)notification
{
    // 执行播放完成代理方法
    if ([_delegate respondsToSelector:@selector(playDidFinish)]) {// 判断代理有没有实现代理方法
        [_delegate playDidFinish];
    }
}

/**
 *  播放
 */

- (void)playerWithUrl:(NSString *)url
{
    // 生成playerItem
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    if (_avPlayer == nil) {
        // 如果没有播放, 直接开始播放
        _avPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        
        // 添加状态监控KVO
        [_avPlayer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        
    } else {
        // 替换成现在播放的歌曲
        [self.avPlayer replaceCurrentItemWithPlayerItem:playerItem];
    }
    _currentUrl = url;
    // 播放
    [_avPlayer play];
    // 启动timer
    _timer.fireDate = [NSDate distantPast];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerStatusReadyToPlay:
            _status = AVPlayerPlaying;
            break;
        case AVPlayerStatusFailed:
            _status = AVPlayerStop;
            break;
        case AVPlayerStatusUnknown:
            // 暂停定时器
            _timer.fireDate = [NSDate distantFuture];
            break;
        default:
            break;
    }
}

/**
 * 播放
 */

- (void)play
{
    [_avPlayer play];
    _status = AVPlayerPlaying;
    _timer.fireDate = [NSDate distantPast];
}
/**
 *  暂停
 */

- (void)pause
{
    [_avPlayer pause];
    _status = AVPlayerPauser;
    _timer.fireDate = [NSDate distantFuture];
}

// 定时器
- (void)timer:(NSTimer *)timer
{
    // 执行代理方法
    if ([_delegate respondsToSelector:@selector(changTime:)]) {
        [_delegate changTime:self.currentTime];
    }
}

- (CGFloat)currentTime
{
    // 计算当前的播放时间
    CGFloat time = _avPlayer.currentItem.currentTime.value / _avPlayer.currentTime.timescale;
    

//    _avPlayer.currentItem.duration 总时长
//    _avPlayer.currentItem.currentTime 当前播放的时间
    
    
    
    return time;
}

/**
 *  根据时间播放歌曲
 *  @param time
 */

- (void)seekToTime:(CGFloat)time
{
    /**
     *跳转到具体的时间点播放
     */
    // 参数一 : 当前时间的值value 用second * timescale计算出
    // 参数二 : 比例 timescale
    [_avPlayer seekToTime:CMTimeMake(time * _avPlayer.currentItem.currentTime.timescale, _avPlayer.currentTime.timescale)];
}

- (void)setVolume:(CGFloat)volume
{
    self.avPlayer.volume = volume;
}

@end
