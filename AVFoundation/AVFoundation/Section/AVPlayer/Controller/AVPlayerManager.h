//
//  AVPlayerManager.h
//  AVF
//
//  Created by shenghuihan on 15/12/30.
//  Copyright © 2015年 shenghuihan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayerManager;

@protocol AVPlayerManagerDelegate <NSObject>
- (void)updataCurrentTime:(double)time duration:(double)duration;
- (void)updataLoadingTimeRange:(double)time;
@end

@interface AVPlayerManager : NSObject

- (instancetype)initWithFrame:(CGRect)rect;

- (void)setPlayUrls:(NSArray *)urls;

- (void)changeVoice;

- (void)play;
- (void)pause;

- (void)next;
- (void)forward;

- (void)setTheProgres:(double)progress;
- (void)needLoop:(BOOL)loop;

- (void)stopUpdataTime;
- (void)startUpdataTime;

- (void)destroyPlayer;

@property (nonatomic, copy) void(^generatorComplete)(NSArray *);
@property (nonatomic, strong) UIView *playerView;
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, weak) id <AVPlayerManagerDelegate> delegate;

@end


