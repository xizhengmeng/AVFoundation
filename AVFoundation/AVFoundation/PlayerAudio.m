//
//  PlayerAudio.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/5.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "PlayerAudio.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerAudio()<AVAudioPlayerDelegate>
@property (nonatomic, strong) UIButton *play1;///<播放本地
@property (nonatomic, strong) UIButton *play2;///<播放网络
@property (nonatomic, strong) AVAudioPlayer*player1;///<播放器
@property (nonatomic, strong) UIButton *play;//播放按钮

@property (nonatomic, strong) UISlider *seekSlider;//进度条
@property (nonatomic, strong) UISlider *voiceSlider;//音量
@property (nonatomic, strong) UISlider *rateSlider;//音量
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) double setTime;
@property (nonatomic, assign) BOOL resetTime;
@property (nonatomic, assign) BOOL isHighlight;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation PlayerAudio

-(void)dealloc {
    NSLog(@"dealloc");
    [self.seekSlider removeObserver:self forKeyPath:@"highlighted"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error;
    //现在可以做到切换静音键的时候，不会被中断
    if (![session setCategory:AVAudioSessionCategoryPlayback error:&error]) {
        NSLog(@"category error:%@", error.localizedDescription);
    }
    
    if (![session setActive:YES error:&error]) {
        NSLog(@"activity error:%@", error.localizedDescription);
    }
    
    //处理中断事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterruption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
    
    //处理线路改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRouteChange:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
    [self createSubviews];

    self.resetTime = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showSeekTime) userInfo:nil repeats:YES];

}

#pragma makr - private
- (void)createSubviews {
    
    [self.view addSubview:self.play1];
    self.play1.x = 100;
    self.play1.y = 100;
    
    [self.view addSubview:self.play2];
    self.play2.x = 100;
    self.play2.y = 150;
    
    [self.view addSubview:self.play];
    self.play.x = 100;
    self.play.y = 200;
    self.play.enabled = NO;
    
    [self.view addSubview:self.seekSlider];
    self.seekSlider.bottom = kScreenH - 20;
    
    [self.view addSubview:self.voiceSlider];
    self.voiceSlider.bottom = self.seekSlider.y - 10;
    self.voiceSlider.right = kScreenW - 20;
    
    [self.view addSubview:self.rateSlider];
    self.rateSlider.right = kScreenW - 20;
    self.rateSlider.bottom = self.voiceSlider.y - 10;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if([keyPath isEqualToString:@"highlighted"])
    {
        UISlider *slider = object;
        if(slider.highlighted == NO && self.isHighlight == YES) {
            [self.player1 pause];
            self.player1.currentTime = self.setTime;
        }
        self.isHighlight = slider.highlighted ? YES : NO;
    }
}

- (void)playFormDisk {
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@".mp3"];
    self.player1 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
    self.player1.enableRate = YES;//想要设置速率，要先设置这个属性
    self.player1.rate = 2.0;
    self.player1.numberOfLoops = -1;
    self.player1.delegate = self;
    if (self.player1) {
        [self.player1 prepareToPlay];
        self.play.enabled = YES;
    }
}

- (void)playFromUrl {
    WEAKSELF;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"AVAudioPlayer不支持边下边播" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
   
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)clickToPlay {
    
    if ([self.play.currentTitle isEqualToString:@"播放"]) {
        [self.player1 play];
        [self.play setTitle:@"暂停" forState:UIControlStateNormal];
    }else {
       [self.player1 pause];
        [self.play setTitle:@"播放" forState:UIControlStateNormal];
    }
}

- (void)showSeekTime {
    
    double tatio = self.player1.currentTime / self.player1.duration * 1.0;
    
    int curentTime = (int)self.player1.currentTime;
    int setTime = (int)self.setTime;

    
    if (self.resetTime && (curentTime == setTime)) {
        self.resetTime = NO;
        [self.player1 play];
    }
    
    if (!self.seekSlider.highlighted && !self.resetTime) {
       [self.seekSlider setValue:tatio animated:YES];
    }
    
}

- (void)sliderValueChanged:(UISlider *)slider {
    float value = slider.value;
    double time = value * self.player1.duration;
//    [self.player1 playAtTime:time];
    
    self.resetTime = YES;
    self.setTime = time;
}

- (void)voiceSliderValueChanged:(UISlider *)slider {
    self.player1.volume = slider.value;
}

- (void)panSliderValueChanged:(UISlider *)slider {
    self.player1.rate = slider.value * 2.0;
}

- (void)handleInterruption:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //打扰开始，更改按钮状态
    }else {
        //打扰结束，更改按钮状态
    }
}

- (void)handleRouteChange:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    AVAudioSessionRouteChangeReason reason = [info[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *previousOutput = previousRoute.outputs[0];
        NSString *portType = previousOutput.portType;
        //如果是耳机
        if ([portType isEqualToString:AVAudioSessionPortHeadphones]) {
            NSLog(@"耳机");
        }
    }
}
#pragma mark - lazyload
- (UIButton *)play1 {
    if (!_play1) {
        _play1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_play1 setTitle:@"播放本地" forState:UIControlStateNormal];
        [_play1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_play1 sizeToFit];
        [_play1 addTarget:self action:@selector(playFormDisk) forControlEvents:UIControlEventTouchUpInside];
    }
    return _play1;
}

- (UIButton *)play2 {
    if (!_play2) {
        _play2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_play2 setTitle:@"播放网络" forState:UIControlStateNormal];
        [_play2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_play2 sizeToFit];
        [_play2 addTarget:self action:@selector(playFromUrl) forControlEvents:UIControlEventTouchUpInside];
    }
    return _play2;
}

- (UIButton *)play {
    if (!_play) {
        _play = [UIButton buttonWithType:UIButtonTypeCustom];
        [_play setTitle:@"播放" forState:UIControlStateNormal];
        [_play setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_play setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_play sizeToFit];
        [_play addTarget:self action:@selector(clickToPlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _play;
}
- (UISlider *)seekSlider {
    if (!_seekSlider) {
        _seekSlider = [[UISlider alloc] init];
        _seekSlider.size = CGSizeMake(kScreenW - 40, 20);
        [_seekSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_seekSlider addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _seekSlider;
}

- (UISlider *)voiceSlider {
    if (!_voiceSlider) {
        _voiceSlider = [[UISlider alloc] init];
        _voiceSlider.size = CGSizeMake(kScreenW - 150, 20);
        [_voiceSlider addTarget:self action:@selector(voiceSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _voiceSlider;
}

- (UISlider *)rateSlider {
    if (!_rateSlider) {
        _rateSlider = [[UISlider alloc] init];
        _rateSlider.size = CGSizeMake(kScreenW - 150, 20);
        [_rateSlider addTarget:self action:@selector(panSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _rateSlider;
}

//其中代理函数有如下几个
- (void)audioplayerdidfinishplaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //播放结束时执行的动作
}
- (void)audioplayerdecodeerrordidoccur:(AVAudioPlayer *)player error:(NSError *)error{
    //解码错误执行的动作
}
- (void)audioplayerbegininteruption:(AVAudioPlayer *)player{
    //处理中断的代码
}
- (void)audioplayerendinteruption:(AVAudioPlayer *)player{
    //处理中断结束的代码
}

@end
