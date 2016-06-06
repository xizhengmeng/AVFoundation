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
    
    if ([btn.titleLabel.text isEqualToString:@"录制"]) {
        [self.voiceRecorder record];
        [btn setTitle:@"录制中" forState:UIControlStateNormal];
        [btn sizeToFit];
    }else if ([btn.titleLabel.text isEqualToString:@"录制中"]) {
        [btn setTitle:@"录制" forState:UIControlStateNormal];
        [btn sizeToFit];
        [self stop];
    }
    
}

- (void)pause {
    [self.voiceRecorder pause];
}

- (void)stop {
    WEAKSELF;
    [self.voiceRecorder stopwithCompletionHander:^(BOOL complete) {
        [weakSelf showAlertView];
    }];
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

- (void)showAlertView {
    WEAKSELF;
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"请输入保存名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.text = @"请输入名称";
    }];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *name = alertVc.textFields[0].text;
      [weakSelf.voiceRecorder saveRecorderWithName:name andCompletionHandler:^(BOOL success) {
          
      }];
        
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    

    [alertVc addAction:action];
    
    [alertVc addAction:cancle];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

@end
