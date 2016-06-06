//
//  AVPlayerView.m
//  AVF
//
//  Created by han on 16/1/2.
//  Copyright © 2016年 shenghuihan. All rights reserved.
//

#import "AVPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "AVPlayerManager.h"
#import "UIView+Metrics.h"
#import "FXSlider.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface AVPlayerView()<AVPlayerManagerDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) UIButton *play;
@property (nonatomic, strong) UIButton *pause;

@property (nonatomic, strong) UIButton *next;
@property (nonatomic, strong) UIButton *forward;

@property (nonatomic, strong) UIProgressView *progeress;
@property (nonatomic, strong) FXSlider *slider;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) AVPlayerManager *manager;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UILabel *nowTime;
@property (nonatomic, strong) UILabel *durationTime;
@property (nonatomic, strong) UIButton *volume;

@property (nonatomic, assign) BOOL isHidden;

@property (nonatomic, strong) UIView *tapView;
@end

@implementation AVPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        self.clipsToBounds = YES;
        self.isHidden = NO;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
//        [self addGestureRecognizer:tap];
        [self addSubview:self.tapView];
        [self.tapView addGestureRecognizer:tap];
    }
    return self;
}

- (void)initViews {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeTheButton)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    self.backgroundColor = [UIColor grayColor];
    
    [self addSubview:self.backView];
    
    [self.backView addSubview:self.play];
    [self.backView addSubview:self.next];
    [self.backView addSubview:self.forward];
    [self.backView addSubview:self.slider];
    [self.backView addSubview:self.nowTime];
    [self.backView addSubview:self.durationTime];
    [self.backView addSubview:self.volume];
    
    [self customVideoSlider];
    self.progeress.frame = self.slider.bounds;
    [self.slider addSubview:self.progeress];
    self.progeress.y += 4;
    
    self.play.x = 2;
    self.play.centerY = self.backView.height * 0.5;
    
    self.next.x = CGRectGetMaxX(self.play.frame) + .05;
    self.next.centerY = self.backView.height * 0.5;
    
    self.forward.x = CGRectGetMaxX(self.next.frame) + 0.5;
    self.forward.centerY = self.backView.height * 0.5;
    
    self.slider.x = CGRectGetMaxX(self.forward.frame) + 5;
    self.slider.centerY = self.backView.height * 0.5;
    
    self.nowTime.x = CGRectGetMaxX(self.forward.frame) + 5;
    self.nowTime.centerY = self.forward.centerY;
    
    self.slider.x = CGRectGetMaxX(self.nowTime.frame) + 5;
    
    self.durationTime.x = CGRectGetMaxX(self.slider.frame) + 5;
    self.durationTime.centerY = self.slider.centerY;
    
    self.volume.x = CGRectGetMaxX(self.durationTime.frame) + 2;
    self.volume.centerY = self.durationTime.centerY;
    
}

- (void)setUrls:(NSMutableArray *)urls {
    _urls = urls;
    [self configurePlayer];
}
//初始化player
- (void)configurePlayer {
    AVPlayerManager *manager = [[AVPlayerManager alloc] initWithFrame:self.bounds];
    
    self.manager = manager;
    manager.delegate = self;
    
    [self addSubview:manager.playerView];
    [self bringSubviewToFront:self.backView];
    [self bringSubviewToFront:self.tapView];
    [manager setPlayUrls:self.urls];
    
    self.backView.y = self.manager.playerView.height - self.backView.height;
}

- (void)changeTheVoleme {
    [self.manager changeVoice];
}

- (void)changeTheButton {
    //    [self.play setTitle:@"S" forState:UIControlStateNormal];
}

//开始触摸slider的时候就停止slider的value值的更新，通过停止监听实现
- (void)touchBegan {
    [self.manager stopUpdataTime];
}

//当手离开slider的时候，首先更新slider的value，然后开始监听视频时间的改变
- (void)touchEnd:(UISlider *)slider {
    
    [self.manager setTheProgres:slider.value];
    
    [self.manager startUpdataTime];
    
}
//更新slider的值以及要显示的时间
- (void)updataCurrentTime:(double)time duration:(double)duration {
    
    self.slider.value = (double)(time * 1.00000) / (double)(duration * 1.00000);
    
    self.nowTime.text = [self convertTime:time];
    
    self.durationTime.text = [self convertTime:duration];
    
}

- (void)updateValue:(UISlider *)slider {
    
    [self.manager pause];
    [self.manager setTheProgres:slider.value];
}

- (void)updataLoadingTimeRange:(double)time {
    [self.progeress setProgress:time animated:YES];
}

- (void)play1 {
    if (self.manager.isPlaying) {
        [self.manager pause];
        [self.play setTitle:@"S" forState:UIControlStateNormal];
    }else {
        [self.manager play];
        [self.play setTitle:@"P" forState:UIControlStateNormal];
    }
    
}

- (void)next1 {
    [self.manager next];
}

- (void)forward1 {
    [self.manager forward];
}

//自定义slider的样式
- (void)customVideoSlider {
    //    self.slider.maximumValue = CMTimeGetSeconds(duration);
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
    [self.slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}

int count = 0;
- (void)tap {
    count ++;
    
    NSLog(@"count++%d", count);
    
    if (count % 2) {
        [UIView animateWithDuration:0.7 animations:^{
            self.backView.y = self.height;
        }];
        
        //            self.isHidden = !self.isHidden;
    }else {
        [UIView animateWithDuration:0.7 animations:^{
            self.backView.y = self.manager.playerView.height - self.backView.height;
        }];
        
    }
    
    //    self.isHidden = !self.isHidden;
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

- (void)destroyPlayer {
    [self.manager destroyPlayer];
}

#pragma mark - 系统事件监听
//当上下拉系统菜单的时候调用
- (void)applicationDidBecomeActive {
    [self.manager play];
}

//当上下拉系统菜单的时候调用
- (void)applicationWillResignActive {
    [self.manager pause];
}

//监听屏幕旋转的时候调用
- (void)statusBarOrientationChange:(NSNotification *)notification

{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeRight) // home键靠右
        
    {
        NSLog(@"向右");
    }
    
    if (
        
        orientation ==UIInterfaceOrientationLandscapeLeft) // home键靠左
    {
        NSLog(@"向左");
    }
}

#pragma mark - lazyload
- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] init];
        _tapView.alpha = 0.1;
        _tapView.frame = CGRectMake(0, 0, kScreenW, self.height - self.backView.height);
    }
    return _tapView;
}

- (UIButton *)volume {
    if (!_volume) {
        _volume = [UIButton buttonWithType:UIButtonTypeCustom];
        [_volume setTitle:@"V" forState:UIControlStateNormal];
        _volume.titleLabel.font = [UIFont systemFontOfSize:10];
        _volume.titleLabel.textColor = [UIColor whiteColor];
        [_volume sizeToFit];
        [_volume addTarget:self action:@selector(changeTheVoleme) forControlEvents:UIControlEventTouchUpInside];
    }
    return _volume;
}

- (UILabel *)nowTime {
    if (!_nowTime) {
        _nowTime = [[UILabel alloc] init];
        _nowTime.font = [UIFont systemFontOfSize:10];
        _nowTime.textColor = [UIColor whiteColor];
        _nowTime.size = CGSizeMake(30, 12);
        _nowTime.text = @"00:00";
    }
    return _nowTime;
}

- (UILabel *)durationTime {
    if (!_durationTime) {
        _durationTime = [[UILabel alloc] init];
        _durationTime.font = [UIFont systemFontOfSize:10];
        _durationTime.textColor = [UIColor whiteColor];
        _durationTime.size = CGSizeMake(30, 12);
        _durationTime.text = @"00:00";
    }
    return _durationTime;
}

- (UIProgressView *)progeress {
    if (!_progeress) {
        _progeress = [[UIProgressView alloc] init];
        _progeress.width = 100;
    }
    return _progeress;
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _backView.frame = CGRectMake(0, 0, kScreenW, 50);
    }
    return _backView;
}

- (FXSlider *)slider {
    if (_slider == nil) {
        _slider = [[FXSlider alloc] initWithFrame:CGRectMake(0, 0, kScreenW * 0.5, 10)];
        [_slider addTarget:self action:@selector(touchBegan) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(touchEnd:) forControlEvents:UIControlEventTouchUpInside];
        _slider.tintColor = [UIColor greenColor];
        _slider.thumbTintColor = [UIColor grayColor];
        _slider.width = 100;
        [_slider setThumbImage:[UIImage imageNamed:@"fx_xyf_videodot"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"fx_xyf_videodot"] forState:UIControlStateHighlighted];
        
    }
    return _slider;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _imageView;
}

- (UIButton *)play {
    if (_play == nil) {
        _play = [UIButton buttonWithType:UIButtonTypeCustom];
        _play.backgroundColor = [UIColor clearColor];
        [_play setTitle:@"P" forState:UIControlStateNormal];
        _play.titleLabel.tintColor = [UIColor blueColor];
        [_play sizeToFit];
        [_play addTarget:self action:@selector(play1) forControlEvents:UIControlEventTouchUpInside];
        _play.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _play;
}

- (UIButton *)next {
    if (_next == nil) {
        _next = [UIButton buttonWithType:UIButtonTypeCustom];
        _next.backgroundColor = [UIColor clearColor];
        [_next setTitle:@"N" forState:UIControlStateNormal];
        _next.titleLabel.textColor = [UIColor blueColor];
        [_next sizeToFit];
        [_next addTarget:self action:@selector(next1) forControlEvents:UIControlEventTouchUpInside];
        _next.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _next;
}

- (UIButton *)forward {
    if (_forward == nil) {
        _forward = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _forward.backgroundColor = [UIColor clearColor];
        [_forward setTitle:@"F" forState:UIControlStateNormal];
        [_forward sizeToFit];
        [_forward addTarget:self action:@selector(forward1) forControlEvents:UIControlEventTouchUpInside];
        _forward.titleLabel.font = [UIFont systemFontOfSize:10];
    }
    return _forward;
}
@end
