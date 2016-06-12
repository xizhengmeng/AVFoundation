//
//  AVPlayerViewController.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/6.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "AVPlayerViewController.h"
#import "AVPlayerView.h"
#import "ImagesShowView.h"

@interface AVPlayerViewController()
@property (nonatomic, strong) AVPlayerView *playerView;
@property (nonatomic, strong) NSMutableArray *showArr;
@property (nonatomic, strong) ImagesShowView *imageShowView;
@end

@implementation AVPlayerViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playerView destroyPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.playerView = [[AVPlayerView alloc] init];
    self.playerView.frame = CGRectMake(0, 0, kScreenW, 250);
    self.playerView.urls = self.showArr;
    
    [self.view addSubview:self.playerView];
    self.playerView.y = 64;
    
    WEAKSELF;
    [self.playerView setGeneratorComplete:^(NSArray *arr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.imageShowView reloadImages:arr];
        });
    }];
    
    [self.view addSubview:self.imageShowView];
    self.imageShowView.y = self.playerView.bottom + 50;
}

- (NSMutableArray *)showArr {
    if (!_showArr) {
        _showArr = [NSMutableArray array];
        NSArray *arr = @[@"http://fx.v.kugou.com/G063/M01/07/17/34YBAFdVQ1WAdoDfAS5bU1epTxQ508.mp4",@"http://fx.v.kugou.com/G070/M04/18/1F/5oYBAFdVNqqAd29OASEupKgCneM091.mp4",@"http://fx.v.kugou.com/G072/M09/00/18/6IYBAFdVNVaAHbshAVJ_9TALO2o246.mp4"];
        
//        NSArray *arr = @[@"http://fx.v.kugou.com/G063/M01/07/17/34YBAFdVQ1WAdoDfAS5bU1epTxQ508.mp4"];
        
        [_showArr addObjectsFromArray:arr];
    }
    return _showArr;
}

- (ImagesShowView *)imageShowView {
    if (!_imageShowView) {
        _imageShowView = [[ImagesShowView alloc] init];
        _imageShowView.backgroundColor = [UIColor orangeColor];
        _imageShowView.size = CGSizeMake(kScreenW, 200);
    }
    return _imageShowView;
}

@end
