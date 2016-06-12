//
//  AVPlayerThumbnails.h
//  AVFoundation
//
//  Created by shenghuihan on 16/6/8.
//  Copyright © 2016年 han1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVPlayerThumbnails : NSObject
@property (nonatomic, copy) void(^generatorComplete)(NSArray *);
- (void)generateThumbnailsWithAsset:(AVAsset *)asset;
@end
