//
//  PhotoManager.h
//  FanXing
//
//  Created by han on 15/12/16.
//  Copyright © 2015年 han. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kNoAlbumCode 999999
#define kHaveNoRight 999997
#define kCreateRequestFail 999996

@interface PhotoManager : NSObject
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

//rename album
+ (void)changeAlbumNameFrom:(NSString *)oldName to:(NSString *)newName;

//delete album
+ (void)deleteAlbumWithName:(NSString *)albumName;

//is have right
+ (void)dealIsHaveAuthorizationRight:(void(^)(BOOL isHaveRight,NSError *error))completeBlock;

@end
