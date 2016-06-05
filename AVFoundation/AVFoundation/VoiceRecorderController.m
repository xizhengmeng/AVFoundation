//
//  VoiceRecorderController.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/5.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "VoiceRecorderController.h"
#import "VoiceRecorder.h"

@interface VoiceRecorderController()
@property (nonatomic, strong) UIButton *recorderBtn;
@property (nonatomic, strong) VoiceRecorder *voiceRecorder;
@end

@implementation VoiceRecorderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.recorderBtn];
    self.recorderBtn.x = 100;
    self.recorderBtn.y = 100;
}

- (void)recordClick:(UIButton *)btn {
    [self.voiceRecorder record];
    [btn setTitle:@"录制中" forState:UIControlStateNormal];
    [btn sizeToFit];
}

- (void)pause {
    [self.voiceRecorder pause];
}

- (VoiceRecorder *)voiceRecorder {
    if (!_voiceRecorder) {
        _voiceRecorder = [[VoiceRecorder alloc] init];
    }
    return _voiceRecorder;
}

- (UIButton *)recorderBtn {
    if (!_recorderBtn) {
        _recorderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recorderBtn setTitle:@"录制" forState:UIControlStateNormal];
        [_recorderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_recorderBtn sizeToFit];
        [_recorderBtn addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recorderBtn;
}

@end
