//
//  MusicCell.m
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "MusicCell.h"
#import <UIImageView+WebCache.h>

@interface MusicCell ()
@property (weak, nonatomic) IBOutlet UIImageView *MusicImageView;
@property (weak, nonatomic) IBOutlet UILabel *MusicName;
@property (weak, nonatomic) IBOutlet UILabel *singer;
@property (weak, nonatomic) IBOutlet UILabel *album;

@end

@implementation MusicCell

/**
 *  为cell赋值
 *  @param musicInfo
 */

- (void)setValueWithMusicInfo:(MusicInfo *)musicInfo
{
    _MusicName.text = musicInfo.name;
    _singer.text = musicInfo.singer;
    _album.text = musicInfo.album;
    [_MusicImageView sd_setImageWithURL:[NSURL URLWithString:musicInfo.picUrl] placeholderImage:[UIImage imageNamed:@"8"]];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
