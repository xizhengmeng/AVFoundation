//
//  AVPlayerView.h
//  AVF
//
//  Created by han on 16/1/2.
//  Copyright © 2016年 shenghuihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVPlayerView : UIView

@property (nonatomic, copy) void(^generatorComplete)(NSArray *);
@property (nonatomic, strong) NSMutableArray *urls;

- (void)destroyPlayer;

@end
