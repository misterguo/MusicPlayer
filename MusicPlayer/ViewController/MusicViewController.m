//
//  MusicViewController.m
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "MusicViewController.h"
#import <UIImageView+WebCache.h>
#import "AVPlayerManager.h"
#import "Tools.h"
#import "MusicInfoHandle.h"
#import "LyricModel.h"
#import "LyricHandle.h"

typedef NS_ENUM(NSUInteger, LoopType) {
    SingleType, // 单曲循环
    ShufflType, // 随机循环
    OrderType, // 顺序循环
};

@interface MusicViewController ()<AVPlayerManagerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BOOL isSeek; // 是否开始拖拽进度条
}
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView; // 音乐图片
@property (weak, nonatomic) IBOutlet UISlider *progressSlider; // 进度条
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView; // 模糊视图
@property (weak, nonatomic) IBOutlet UIButton *dismissButton; // 页面消失按钮
@property (weak, nonatomic) IBOutlet UITableView *tableView; // 歌词列表
@property (weak, nonatomic) IBOutlet UILabel *currentPlayTime; // 当前播放时间
@property (weak, nonatomic) IBOutlet UILabel *remainTime; // 剩余时间标签
@property (weak, nonatomic) IBOutlet UILabel *name; // 歌曲名字
@property (weak, nonatomic) IBOutlet UILabel *singer; // 歌手
@property (weak, nonatomic) IBOutlet UIButton *lastestButton; // 上一首
@property (weak, nonatomic) IBOutlet UIButton *nextButton; // 下一首
@property (weak, nonatomic) IBOutlet UIButton *playButton; // 播放/暂停按钮
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider; // 音量滑动条
@property (weak, nonatomic) IBOutlet UIButton *singleLoopButton; // 单曲循环按钮
@property (weak, nonatomic) IBOutlet UIButton *loopButton; // 顺序循环按钮
@property (weak, nonatomic) IBOutlet UIButton *randomButton; // 随即播放按钮
@property (nonatomic) LoopType loopType; // 播放类型


@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    // 设置音乐图片圆角
    _musicImageView.layer.cornerRadius = ([UIScreen mainScreen].bounds.size.width - 100) / 2;
    _musicImageView.layer.masksToBounds = YES;
    self.navigationController.navigationBar.hidden = YES;
    
    // 设置进度条
    [_progressSlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
   
    // 设置播放器的代理
    [AVPlayerManager shareManager].delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = 0;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.volumeSlider.minimumValue = 0.0;
    self.volumeSlider.maximumValue = 10;
    self.volumeSlider.value = 4;
    
    self.loopType = OrderType;
     [self setUpView];
}

/**
 *  播放页面
 */
- (void)setUpView
{
    [_musicImageView sd_setImageWithURL:[NSURL URLWithString:_musicInfo.picUrl] placeholderImage:[UIImage imageNamed:@"8"]];
    [_blurImageView sd_setImageWithURL:[NSURL URLWithString:_musicInfo.blurPicUrl] placeholderImage:[UIImage imageNamed:@"8"]];
    [[AVPlayerManager shareManager] playerWithUrl:_musicInfo.mp3Url];
    [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    _name.text = _musicInfo.name;
    _singer.text = [NSString stringWithFormat:@"%@--%@", _musicInfo.singer, _musicInfo.album];
    
    // 设置progressSlider min max
    _progressSlider.minimumValue = 0;
    _progressSlider.maximumValue = _musicInfo.totalTime;
    _progressSlider.value = 0;
    // 当前时间, 剩余时间label赋值
    _remainTime.text = [Tools timeStrFromSeconds:_musicInfo.totalTime];
    [[LyricHandle shareHandle] changLyricString:_musicInfo.lyric];
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Regesture
- (IBAction)dismiss:(id)sender {
    // 返回上一页
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 时间进度条改变
- (IBAction)progressChang:(id)sender {
    // 改变歌曲播放进度
    [[AVPlayerManager shareManager] seekToTime:_progressSlider.value];
    isSeek = NO;
}

// 时间进度条触摸
- (IBAction)progressTouchDown:(id)sender {
    isSeek = YES;
}

// 上一首
- (IBAction)last:(id)sender {

    if (self.index == 0) {
        self.index = [[MusicInfoHandle shareHandle] MusicCount] - 1;
    } else {
        self.index -= 1;
    }
    self.musicInfo = [[MusicInfoHandle shareHandle] MusicInfoWithIndex:self.index];
    
    [self setUpView];
}
// 播放/暂停
- (IBAction)play:(id)sender {
    if ([AVPlayerManager shareManager].status == AVPlayerPauser) {
        [[AVPlayerManager shareManager] play];
        [_playButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    } else if ([AVPlayerManager shareManager].status == AVPlayerPlaying) {
        [[AVPlayerManager shareManager] pause];
        [_playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}
// 下一首
- (IBAction)next:(id)sender {
    switch (_loopType) {
        case SingleType:
           
            [self setUpView];
            break;
        case ShufflType:
            self.index = arc4random() % [[MusicInfoHandle shareHandle] MusicCount];
            self.musicInfo = [[MusicInfoHandle shareHandle] MusicInfoWithIndex:self.index];
            [self setUpView];
            break;
        case OrderType:
            if (self.index == [[MusicInfoHandle shareHandle] MusicCount]) {
                self.index = 0;
            } else {
                self.index += 1;
            }
            self.musicInfo = [[MusicInfoHandle shareHandle] MusicInfoWithIndex:self.index];
            [self setUpView];
            break;
        default:
            break;
    }

}
// 音量大小进度条
- (IBAction)volumeChangeValue:(id)sender
{
    [[AVPlayerManager shareManager] setVolume:self.volumeSlider.value];
}
/**
 * 判断列表循环状态
 */
- (void)changeLoopTypewithLoopType:(LoopType)loopType
{
    // 将所有的按钮状态设置为灰色
    [_singleLoopButton setImage:[UIImage imageNamed:@"singleloop"] forState:(UIControlStateNormal)];
    [_randomButton setImage:[UIImage imageNamed:@"shuffle"] forState:(UIControlStateNormal)];
    [_loopButton setImage:[UIImage imageNamed:@"loop"] forState:(UIControlStateNormal)];
    
    // 判断当前为哪个状态
    switch (loopType) {
        case SingleType:
            [_singleLoopButton setImage:[UIImage imageNamed:@"singleloop-s"] forState:(UIControlStateNormal)];
            break;
            
        case ShufflType:
            [_randomButton setImage:[UIImage imageNamed:@"shuffle-s"] forState:(UIControlStateNormal)];
            break;
            
        case OrderType:
            [_loopButton setImage:[UIImage imageNamed:@"loop-s"] forState:(UIControlStateNormal)];
            break;
    }
    
    // 更改状态
    if (_loopType != loopType) {
        _loopType = loopType;
    }
    
}
// 单曲循环
- (IBAction)singleLoop:(id)sender {
    [self changeLoopTypewithLoopType:SingleType];

}
// 顺序循环播放
- (IBAction)loop:(id)sender {

    
    [self changeLoopTypewithLoopType: OrderType];

}
// 随机播放
- (IBAction)shuffle:(id)sender {
    [self changeLoopTypewithLoopType:ShufflType];

}
- (IBAction)typeButton:(id)sender {
    if (_musicImageView.layer.cornerRadius == ([UIScreen mainScreen].bounds.size.width - 100) / 2) {
        // 取消圆角
        _musicImageView.layer.cornerRadius = 0;
        _musicImageView.transform = CGAffineTransformMakeRotation(0);
    } else {
        _musicImageView.layer.cornerRadius = ([UIScreen mainScreen].bounds.size.width - 100) / 2;
    }
}

#pragma mark - AVPlayerManagerDelegate
- (void)changTime:(CGFloat)time
{
    // 改变进度条进度
    if (!isSeek) {
        _progressSlider.value = time;
    }
    // 改变播放时间
    _currentPlayTime.text = [Tools timeStrFromSeconds:time];

    // 音乐图片旋转
    if (_musicImageView.layer.cornerRadius == ([UIScreen mainScreen].bounds.size.width - 100) / 2) {
    [UIView animateWithDuration:0.1 animations:^{
      _musicImageView.transform = CGAffineTransformRotate(_musicImageView.transform, 0.02);
        }];
    }
    
    _remainTime.text = [Tools timeStrFromSeconds:_musicInfo.totalTime - time];
    // 歌词
    NSInteger index = [[LyricHandle shareHandle] lyricItemWithTime:time];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
}
// 播放完成
- (void)playDidFinish
{
    [self next:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[LyricHandle shareHandle] lyricItemCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[LyricHandle shareHandle] lyricStringWithIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor greenColor];
    cell.textLabel.highlightedTextColor = [UIColor orangeColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
