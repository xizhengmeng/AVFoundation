//
//  ViewController.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/5.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "ViewController.h"
#import "SpeechSynthesizer.h"
#import "PlayerAudio.h"
#import "VoiceRecorderController.h"
#import "AVPlayerViewController.h"
#import "ReaderAndWriterVC.h"
#import "CameraViewController.h"
#define CELL @"cell"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ViewController
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:@[@"1.文本到语音",@"2.播放音乐AVAuidoPlayer",@"3.录音",@"4.播放视频",@"5.AVAssetReader and writer",@"6.照相",@"7.录像"]];
    }
    return _dataArr;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    self.title = @"AVFoundation";
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    NSString *name;
    if (indexPath.row < self.dataArr.count) {
        name = self.dataArr[indexPath.row];
    }
    cell.textLabel.text = name;
    //code
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            SpeechSynthesizer *sp = [[SpeechSynthesizer alloc] init];
            [self.navigationController pushViewController:sp animated:YES];
        }
            break;
        case 1:
        {
            PlayerAudio *audio = [[PlayerAudio alloc] init];
            [self.navigationController pushViewController:audio animated:YES];
        }
            break;
        case 2:
        {
            VoiceRecorderController *voiceR = [[VoiceRecorderController alloc] init];
            [self.navigationController pushViewController:voiceR animated:YES];
        }
            break;
        case 3:
        {
            AVPlayerViewController *avplayer = [[AVPlayerViewController alloc] init];
            [self.navigationController pushViewController:avplayer animated:YES];
        }
            break;
        case 4:
        {
            ReaderAndWriterVC *vc = [[ReaderAndWriterVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            CameraViewController *vc = [[CameraViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

@end

