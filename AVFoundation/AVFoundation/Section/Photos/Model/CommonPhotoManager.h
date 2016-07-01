//
//  CommonPhotoManager.h
//  FanXing
//
//  Created by 洪锐堉 on 15/12/25.
//  Copyright © 2015年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonPhotoManager : NSObject

//save image or video to defealt album
+ (void)saveImageToSystemAlbumWithImage:(UIImage *)image
                                succeed:(void(^)())successBlock
                                   fail:(void(^)(NSError *error))errorBlock;

+ (void)saveVideoToSystemAlbumWithUrl:(NSURL *)videoUrl
                              succeed:(void(^)())successBlock
                                 fail:(void(^)(NSError *error))errorBlock;


//save image or video to selected album
+ (void)saveImageWithImage:(UIImage *)image
      toAlbumWithAlbumName:(NSString *)albumName
                   succeed:(void(^)())successBlock
                      fail:(void(^)(NSError *error))errorBlock;

+ (void)saveVideoWithUrl:(NSURL *)videoUrl
    toAlbumWithAlbumName:(NSString *)albumName
                 succeed:(void(^)())successBlock
                    fail:(void(^)(NSError *error))errorBlock;

//create album
+ (void)createAlbumWithAlbumName:(NSString *)AlbumName
                         succeed:(void(^)())successBlock
                            fail:(void(^)(NSError *error))errorBlock;

//album is exist
+ (void)isAlbumExistWithName:(NSString*)albumName
               completeBlock:(void(^)(BOOL isExist))completeBlock;

//is have right
+ (void)dealIsHaveAuthorizationRight:(void(^)(BOOL isHaveRight,NSError *error))completeBlock;

@end
