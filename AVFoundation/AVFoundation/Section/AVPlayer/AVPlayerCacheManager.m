//
//  AVPlayerCacheManager.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/7.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "AVPlayerCacheManager.h"

@implementation AVPlayerCacheManager

+ (void)getMetadataWithAsset:(AVAsset *)asset {
    NSArray *keys = @[@"availableMetadataFormats"];
    
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        NSMutableArray *metadata = [NSMutableArray array];
        
        for (NSString *format in asset.availableMetadataFormats) {
            [metadata addObjectsFromArray:[asset metadataForFormat:format]];
        }
        AVMetadataItem *item = metadata.firstObject;
        NSLog(@"metadata-->%@", item.value);
    }];
}

@end
