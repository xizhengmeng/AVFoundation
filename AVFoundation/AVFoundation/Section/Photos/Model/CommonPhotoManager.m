//
//  CommonPhotoManager.m
//  FanXing
//
//  Created by 洪锐堉 on 15/12/25.
//  Copyright © 2015年 kugou. All rights reserved.
//

#import "CommonPhotoManager.h"
#import "PhotoManager.h"
#import "AssetLibraryManager.h"

@implementation CommonPhotoManager

+ (void)saveImageToSystemAlbumWithImage:(UIImage *)image
                                succeed:(void(^)())successBlock
                                   fail:(void(^)(NSError *error))errorBlock {
    
#ifdef __IPHONE_8_0
    if (iOS8) {
        [PhotoManager saveImageToSystemAlbumWithImage:image succeed:successBlock fail:errorBlock];
    } else {

        [[AssetLibraryManager sharedInstance] saveImageToSystemAlbumWithImage:image succeed:successBlock fail:errorBlock];
        
    }
#else
    [[AssetLibraryManager sharedInstance] saveImageToSystemAlbumWithImage:image succeed:successBlock fail:errorBlock];
    
#endif
    
    
}

+ (void)saveVideoToSystemAlbumWithUrl:(NSURL *)videoUrl
                              succeed:(void(^)())successBlock
                                 fail:(void(^)(NSError *error))errorBlock {
    
#ifdef __IPHONE_8_0
    
    if (iOS8) {
        [PhotoManager saveVideoToSystemAlbumWithUrl:videoUrl succeed:successBlock fail:errorBlock];
    } else {
        
        [[AssetLibraryManager sharedInstance] saveVideoToSystemAlbumWithUrl:videoUrl succeed:successBlock fail:errorBlock];
    }
    
#else
    
    [[AssetLibraryManager sharedInstance] saveVideoToSystemAlbumWithUrl:videoUrl succeed:successBlock fail:errorBlock];
    
#endif
}


+ (void)saveImageWithImage:(UIImage *)image
      toAlbumWithAlbumName:(NSString *)albumName
                   succeed:(void(^)())successBlock
                      fail:(void(^)(NSError *error))errorBlock {
#ifdef __IPHONE_8_0
    
    if (iOS8) {
        [PhotoManager saveImageWithImage:image toAlbumWithAlbumName:albumName succeed:successBlock fail:errorBlock];
    } else {
        [[AssetLibraryManager sharedInstance] saveImageWithImage:image toAlbumWithAlbumName:albumName succeed:successBlock fail:errorBlock];
    }
    
#else
    
    [[AssetLibraryManager sharedInstance] saveImageWithImage:image toAlbumWithAlbumName:albumName succeed:successBlock fail:errorBlock];
    
#endif
    
}

+ (void)saveVideoWithUrl:(NSURL *)videoUrl
    toAlbumWithAlbumName:(NSString *)albumName
                 succeed:(void(^)())successBlock
                    fail:(void(^)(NSError *error))errorBlock {
    
#ifdef __IPHONE_8_0
    
    if (iOS8) {
        [PhotoManager saveVideoWithUrl:videoUrl toAlbumWithAlbumName:albumName succeed:successBlock fail:errorBlock];
    } else {
        [[AssetLibraryManager sharedInstance] saveVideoWithUrl:videoUrl toAlbumWithAlbumName:albumName succeed:successBlock fail:errorBlock];
    }
    
#else
    
    [[AssetLibraryManager sharedInstance] saveVideoWithUrl:videoUrl toAlbumWithAlbumName:albumName succeed:successBlock fail:errorBlock];
    
#endif
}

+ (void)createAlbumWithAlbumName:(NSString *)AlbumName
                         succeed:(void(^)())successBlock
                            fail:(void(^)(NSError *error))errorBlock {
    
#ifdef __IPHONE_8_0
    
    if (iOS8) {
        [PhotoManager createAlbumWithAlbumName:AlbumName succeed:successBlock fail:errorBlock];
    } else {
        
        [[AssetLibraryManager sharedInstance] createAlbumWithAlbumName:AlbumName succeed:successBlock fail:errorBlock];
    }
    
#else
    
    [[AssetLibraryManager sharedInstance] createAlbumWithAlbumName:AlbumName succeed:successBlock fail:errorBlock];
    
#endif
}

+ (void)isAlbumExistWithName:(NSString*)albumName
               completeBlock:(void(^)(BOOL isExist))completeBlock{
 
#ifdef __IPHONE_8_0
    
    if (iOS8) {
        [PhotoManager isAlbumExistWithName:albumName completeBlock:completeBlock];
    } else {
        
        [[AssetLibraryManager sharedInstance] isAlbumExistWithName:albumName completeBlock:completeBlock];
    }
    
#else
    
    [[AssetLibraryManager sharedInstance] isAlbumExistWithName:albumName completeBlock:completeBlock];
    
#endif
    
}

+ (void)dealIsHaveAuthorizationRight:(void(^)(BOOL isHaveRight,NSError *error))completeBlock {
    
#ifdef __IPHONE_8_0
    
    if (iOS8) {
        [PhotoManager dealIsHaveAuthorizationRight:completeBlock];
    } else {
        
        [[AssetLibraryManager sharedInstance] dealIsHaveAuthorizationRight:completeBlock];
    }
    
#else
    
    [[AssetLibraryManager sharedInstance] dealIsHaveAuthorizationRight:completeBlock];
    
#endif
}
@end
