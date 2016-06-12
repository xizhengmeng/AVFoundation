//
//  AVPlayerCacheManager.h
//  AVFoundation
//
//  Created by shenghuihan on 16/6/7.
//  Copyright © 2016年 han1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVPlayerCacheManager : NSObject

+ (void)getMetadataWithAsset:(AVAsset *)asset;

@end
