//
//  AVPlayerThumbnails.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/8.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "AVPlayerThumbnails.h"
#import "THThumbnail.h"

@interface AVPlayerThumbnails()
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;

@end

@implementation AVPlayerThumbnails

- (void)generateThumbnailsWithAsset:(AVAsset *)asset {
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    self.imageGenerator.maximumSize = CGSizeMake(200.0f, 0.0f);
    
    CMTime duration = asset.duration;
    
    NSMutableArray *times = [NSMutableArray array];
    CMTimeValue increment = duration.value / 20;
    CMTimeValue currentValue = kCMTimeZero.value;
    
    while (currentValue < duration.value) {
        CMTime time = CMTimeMake(currentValue, duration.timescale);
        [times addObject:[NSValue valueWithCMTime:time]];
        currentValue += increment;
    }
    
    __block NSUInteger imageCount = times.count;
    __block NSMutableArray *images = [NSMutableArray array];
    
    AVAssetImageGeneratorCompletionHandler handler;
    
    handler = ^(CMTime requestedTime, CGImageRef imageRef, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result == AVAssetImageGeneratorSucceeded) {
            UIImage *image = [UIImage imageWithCGImage:imageRef];
            THThumbnail *thumbnail = [THThumbnail thumbnailWithImage:image time:actualTime];
            [images addObject:thumbnail];
        }else {
            NSLog(@"failed to create thenail image");
        }
        
        if (--imageCount == 0) {
            
                NSLog(@"截取完成%@", images);
                if (self.generatorComplete) {
                    self.generatorComplete(images);
                }
        }
    };
    
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:handler];
}

@end
