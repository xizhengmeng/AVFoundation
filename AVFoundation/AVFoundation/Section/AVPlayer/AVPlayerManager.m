//
//  AVPlayerManager.m
//  AVF
//
//  Created by shenghuihan on 15/12/30.
//  Copyright © 2015年 shenghuihan. All rights reserved.
//

#import "AVPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPVolumeView.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import "UIView+Metrics.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define FXMAX_RECONNECT_TIMES 3

@interface AVPlayerManager()
@property (nonatomic, strong) AVQueuePlayer *queuePlayer;
@property (nonatomic, strong) NSMutableArray *playerItemArr;

@property (nonatomic, strong) id timeObserver;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) BOOL needLoop;

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) int currentProgress;

@property (nonatomic, strong) AVVideoComposition *videoComposition;

@property (nonatomic, strong) UIImageView *showImageView;

@property (nonatomic, strong) NSMutableArray *showImages;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, assign) NSInteger reconnectCount;

@property (nonatomic, assign) BOOL canUpdate;
@property (nonatomic, assign) BOOL isError;


@property (nonatomic, assign) double bufferTime;
@property (nonatomic, assign) double nowTime;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation AVPlayerManager

- (void)destroyPlayer {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.queuePlayer pause];
    [self.queuePlayer removeAllItems];
    [self.queuePlayer removeTimeObserver:self.timeObserver];
    
    for (AVPlayerItem *item in self.playerItemArr) {
        [item removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
    
    self.queuePlayer = nil;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.size = CGSizeMake(50, 50);
    }
    return _indicatorView;
}

- (UIImageView *)showImageView {
    if (_showImageView == nil) {
        _showImageView = [[UIImageView alloc] init];
        _showImageView.backgroundColor = [UIColor clearColor];
        _showImageView.image = [UIImage imageNamed:@"001"];
        [_showImageView addSubview:self.indicatorView];
    }
    return _showImageView;
}

- (UIView *)playerView {
    if (_playerView == nil) {
        _playerView = [[UIView alloc] init];
        _playerView.backgroundColor = [UIColor clearColor];
        [_playerView addSubview:self.showImageView];
    }
    return _playerView;
}

- (NSMutableArray *)playerItemArr {
    if (_playerItemArr == nil) {
        _playerItemArr = [NSMutableArray array];
    }
    return _playerItemArr;
}

- (instancetype)initWithFrame:(CGRect)rect {
    if (self = [super init]) {
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(someMethod:)
//                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
        self.frame = rect;
        self.needLoop = NO;
    }
    return self;
}

- (void)changeVoice {
    
//    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
//    self.reconnectCount += 0.2;
//    mpc.volume = 0.2;
    
//    self.reconnectCount += 0.2;
//
    self.reconnectCount = self.reconnectCount ? 0 : 1;
    
    AVAsset *asset = self.queuePlayer.currentItem.asset;
    
    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
    
    NSMutableArray *allAudioParams = [NSMutableArray array];
    
    for (AVAssetTrack *track in audioTracks) {
        
        AVMutableAudioMixInputParameters *audioInputParams =
        [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
        
        [audioInputParams setVolume:self.reconnectCount atTime:kCMTimeZero];

        [allAudioParams addObject:audioInputParams];
        
    }
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    
    AVPlayerItem *item = self.queuePlayer.currentItem;
    
    [item setAudioMix:audioMix];

}

- (void)setPlayUrls:(NSArray *)urls {
    for (int i = 0; i < urls.count; i++) {
        
        id url = urls[i];
        
        if ([url isKindOfClass:[NSString class]]) {
            url = [NSURL URLWithString:url];
        }
        
        AVAsset *asset = [AVAsset assetWithURL:url];

        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];

        [self.playerItemArr addObject:item];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(nextVideo:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:item ];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemFailedToPlayToEndTime:) name:AVPlayerItemPlaybackStalledNotification object:item];
        
        if (i == 0) {
            [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        }
        
        [item  addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.showImages = [self getTheShowImagesWithUrls:urls];
//    });
    
    self.reconnectCount = 0;
    [self initPlayer];
}

- (void)play {
    [self.queuePlayer play];
    self.isPlaying = YES;
    NSLog(@"isPlaying");
}
- (void)pause {
    [self.queuePlayer pause];
    self.isPlaying = NO;
    NSLog(@"isNotPlaying");
}

- (void)next {
    
    AVPlayerItem *currentItem = self.queuePlayer.currentItem;

    [self.queuePlayer pause];
    [self.queuePlayer advanceToNextItem];
    
    [currentItem seekToTime:kCMTimeZero];
    [self.queuePlayer play];
    
    self.currentProgress = 0;
    
    [self.queuePlayer insertItem:currentItem afterItem:nil];
    NSLog(@"new%@", self.queuePlayer.items);
    
}
- (void)forward {

    //1.把最后一个挪到第二个
    NSArray *arr = self.queuePlayer.items;
    AVPlayerItem *item = (AVPlayerItem *)arr.lastObject;
    [self.queuePlayer removeItem:item];
    //2.取出当前的item
    AVPlayerItem *currentItem = self.queuePlayer.currentItem;
    [currentItem seekToTime:kCMTimeZero];
    //3.next
    [self.queuePlayer insertItem:item afterItem:currentItem];
    [self.queuePlayer pause];
    [self.queuePlayer advanceToNextItem];
    [self.queuePlayer play];
    
    self.currentProgress = 0;
    
    [self.queuePlayer insertItem:currentItem afterItem:item];
    //把取出的当前的item移动到第二个
    NSLog(@"new%@", self.queuePlayer.items);
    
}

- (void)setTheProgres:(double)progress {
    self.canUpdate = NO;

    AVPlayerItem *item = self.queuePlayer.currentItem;
     CMTime time = CMTimeMakeWithSeconds(progress * self.duration, NSEC_PER_SEC);
     self.currentProgress = (int)CMTimeGetSeconds(time);
    [item seekToTime:CMTimeMakeWithSeconds(progress * self.duration, NSEC_PER_SEC)];

    NSLog(@"setTheProgress--%d", self.currentProgress);
}

- (void)needLoop:(BOOL)loop {
    self.needLoop = loop;
}

- (void)addItems:(NSArray *)items {
    AVPlayerItem *firstItem = items.firstObject;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:items];
    [arr removeObject:firstItem];
    NSLog(@"1----item%@", self.queuePlayer.items);
    for (AVPlayerItem *item in arr) {
        
        [self.queuePlayer insertItem:item afterItem:firstItem];
        firstItem = item;
    }
    NSLog(@"2----item%@", self.queuePlayer.items);
}

- (void)initPlayer {
    //重新连接的时候，先停止播放
    if (self.queuePlayer) {
        [self.queuePlayer pause];
    }
    
    if (self.playerItemArr.count) {
        //释放原来的queue，重新创建
        NSArray *arr = @[self.playerItemArr.firstObject];
        self.queuePlayer = [AVQueuePlayer queuePlayerWithItems:arr];
        self.queuePlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.queuePlayer];

        playerLayer.frame = CGRectMake(0, 0, kScreenW, self.frame.size.height);
        //设置视频的内容与layer的rect的匹配关系，类似图片的匹配
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.playerView.frame = self.frame;
        self.showImageView.frame = self.playerView.bounds;
        self.indicatorView.center = CGPointMake(self.showImageView.width * 0.5, self.showImageView.height * 0.5);
        [self.indicatorView startAnimating];
        [self.playerView.layer addSublayer:playerLayer];
        //    playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        
        [self addPlayerItemObsever];
    }
}

//网络不佳或者缓冲的时候调用该方法
- (void)playerItemFailedToPlayToEndTime:(NSNotification *)notification {

    NSLog(@"error--%@", notification.userInfo);
    
    self.isError = YES;
    
}

-(void) nextVideo:(NSNotification*)notif {
    
    AVPlayerItem *currItem = notif.object;
   
    [self.queuePlayer advanceToNextItem];
    [self.queuePlayer pause];
    [currItem seekToTime:kCMTimeZero];
    [self.queuePlayer play];
    self.currentProgress = 0;
    [self.queuePlayer insertItem:currItem afterItem:nil];
    NSLog(@"new%@", self.queuePlayer.items);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    WEAKSELF;
    AVPlayerItem *item1 = (AVPlayerItem *)object;
    NSLog(@"%ld", item1.status);
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        NSLog(@"statues---%ld", item.status);
//        NSArray *audioTracks = [item.asset tracksWithMediaType:AVMediaTypeAudio];
//        NSArray *videoTracks = [item.asset tracksWithMediaType:AVMediaTypeVideo];
        
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"you can play");
            [self.queuePlayer play];
            
            [self performSelector:@selector(prepareFOrLoadMore) withObject:nil afterDelay:5];
            
        }else {
            NSLog(@"无法播放");
            //重新连接然后播放
            [self.queuePlayer pause];
            if (self.reconnectCount < FXMAX_RECONNECT_TIMES) {
                [self initPlayer];
                self.reconnectCount ++;
            }else {
                //网络不好，飞行模式的时候处理错误
                [self.queuePlayer pause];
                [self.queuePlayer setRate:0];
                
                [self.queuePlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
                [self.queuePlayer.currentItem removeObserver:self forKeyPath:@"status" context:nil];
                [self.queuePlayer replaceCurrentItemWithPlayerItem:nil];
                self.duration = 0;
                //            self.cusromPlayer.player.currentItem = nil;
                self.queuePlayer = nil;
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                [self.queuePlayer.currentItem cancelPendingSeeks];
                [self.queuePlayer.currentItem.asset cancelLoading];

            }
            
        }
        
    }
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        if (self.isError) {
            self.isError = NO;
            [self.queuePlayer pause];
            [self.queuePlayer play];
        }
        double bufferTime = [self availableDuration];
        self.bufferTime = bufferTime;
        NSLog(@"缓冲进度%f",bufferTime);
        double durationTime = CMTimeGetSeconds(self.queuePlayer.currentItem.duration);
        if ([self.delegate respondsToSelector:@selector(updataLoadingTimeRange:)]) {
            [self.delegate updataLoadingTimeRange:bufferTime/durationTime];
        }
//        [self.progressView setProgress:bufferTime/durationTime animated:YES];
    }

}

- (void)prepareFOrLoadMore {
    WEAKSELF;
    if (self.queuePlayer.items.count == self.playerItemArr.count) return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [weakSelf addItems:self.playerItemArr];
    });
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [self.queuePlayer.currentItem loadedTimeRanges];CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    double startSeconds = CMTimeGetSeconds(timeRange.start);
    double durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)addPlayerItemObsever {
    __block NSInteger count = 0;
    CMTime interval = CMTimeMakeWithSeconds(0.1, NSEC_PER_SEC);
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    __weak __typeof(&*self)weakSelf = self;
    
    void(^callBack)(CMTime time) = ^(CMTime time) {
        NSTimeInterval currentTime = CMTimeGetSeconds(weakSelf.queuePlayer.currentItem.currentTime);
        NSTimeInterval duration = CMTimeGetSeconds(weakSelf.queuePlayer.currentItem.duration);
        weakSelf.duration = duration;
        weakSelf.nowTime = currentTime;
        count ++;
//        NSLog(@"currentTime---%d", (int)currentTime);
        //主要为了解决回调的时间与拖动设置的时间不一致的时候，slider跳动的问题，所以对时间取整，然后进行判断，降低精度，进行模糊处理
        if ((self.currentProgress == (int)currentTime)) {
            self.canUpdate = YES;
        }
        
        if (self.canUpdate) {
            [self.delegate updataCurrentTime:currentTime duration:duration];

        }
    };
    
    self.timeObserver = [self.queuePlayer addPeriodicTimeObserverForInterval:interval queue:queue usingBlock:callBack];
    
}

- (void)stopUpdataTime {
    [self.queuePlayer removeTimeObserver:self.timeObserver];
}

- (void)startUpdataTime {
    
    [self addPlayerItemObsever];

}

- (NSMutableArray *)getTheShowImagesWithUrls:(NSArray *)urls {
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 0; i < urls.count; i++) {
        [images addObject:[self getVideoImageWithPathUrl:urls[i] size:self.frame.size atTime:0]];
    }
    
    return images;
}

- (UIImage *)getVideoImageWithPathUrl:(NSURL *)pathUrl size:(CGSize)size atTime:(NSTimeInterval)atTime
{
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    
    NSTimeInterval totalTime = [self getVideoTimeWithPathUrl:pathUrl];
    
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:pathUrl options:opts];
    
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    generator.appliesPreferredTrackTransform = YES;
    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    //    if (atTime != 0) {
    //        generator.requestedTimeToleranceAfter = kCMTimeZero;
    //        generator.requestedTimeToleranceBefore = kCMTimeZero;
    //    }
    generator.maximumSize = size;
    
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(atTime * totalTime, totalTime) actualTime:NULL error:&error];
    UIImage *image = [UIImage imageWithCGImage: img];
    CGImageRelease(img);
    
    if (!image) {
        image = [UIImage imageNamed:@"001"];
    }
    
    return image;
}

- (NSTimeInterval)getVideoTimeWithPathUrl:(NSURL *)pathUrl
{
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:pathUrl options:nil];
    
    CMTime audioDuration = audioAsset.duration;
    
    return CMTimeGetSeconds(audioDuration);
}

@end
