//
//  MusicListTableViewController.m
//  MusicPlayer
//
//  Created by 郭亚 on 16/5/11.
//  Copyright © 2016年 郭亚. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicInfoHandle.h"
#import "MusicCell.h"
#import "AVPlayerManager.h"
#import "MusicViewController.h"
#import "MBProgressHUD.h"

#define kMusicURL @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"

@interface MusicListTableViewController ()

@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"音乐列表";
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.labelText = @"正在加载...";
    [self loadData];
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [[MusicInfoHandle shareHandle] getMusicInfoWithUrl:kMusicURL completion:^(NSArray *musicInfos, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (error) {
            NSLog(@"%@", error);
        } else {
            [weakSelf.tableView reloadData];
                    }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[MusicInfoHandle shareHandle] numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MusicInfo *musicInfo = [[MusicInfoHandle shareHandle] MusicInfoForRowAtIndexPath:indexPath];
    [cell setValueWithMusicInfo:musicInfo];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicInfo *musicInfo = [[MusicInfoHandle shareHandle] MusicInfoForRowAtIndexPath:indexPath];
    MusicViewController *musicVC = nil;
    if ([AVPlayerManager shareManager].playVC && [((MusicViewController *)[AVPlayerManager shareManager].playVC) musicInfo].Id  == musicInfo.Id) {
        musicVC = (MusicViewController *)[AVPlayerManager shareManager].playVC;
    } else {
    musicVC = [[MusicViewController alloc] init];
    musicVC.musicInfo = [[MusicInfoHandle shareHandle] MusicInfoForRowAtIndexPath:indexPath];
    musicVC.index = indexPath.row;
        [AVPlayerManager shareManager].playVC = musicVC;
    }
    [self presentViewController:musicVC animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
