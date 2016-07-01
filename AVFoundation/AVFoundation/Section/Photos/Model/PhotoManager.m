//
//  PhotoManager.m
//  FanXing
//
//  Created by han on 15/12/16.
//  Copyright © 2015年 han. All rights reserved.
//

#import "PhotoManager.h"
#import <Photos/Photos.h>

@interface PhotoManager()
@end

@implementation PhotoManager

//系统相册
+ (void)saveImageToSystemAlbumWithImage:(UIImage *)image
                                succeed:(void(^)())successBlock
                                   fail:(void(^)(NSError *error))errorBlock{
    
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:[PHFetchOptions new]];
    //遍历相册，找到自己想要的那个
      if(collections!=nil && collections.count!=0) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //请求创建一个AssetChangeRequest
            [PHAssetChangeRequest creationRequestForAssetFromImage:image];

        } completionHandler:^(BOOL success, NSError *error) {
            
            if(success) {
                
                if(successBlock)
                    successBlock();
                
            } else {
                
                if(errorBlock)
                    errorBlock(error);
            }
        }];
          
    } else {

        NSError* error = [NSError errorWithDomain:@"没有该相册"
                                             code:kNoAlbumCode
                                         userInfo:@{NSLocalizedDescriptionKey:@"没有该相册"}];
        if(errorBlock) {
            errorBlock(error);
        }
    }
}

//存到系统相册
+ (void)saveVideoToSystemAlbumWithUrl:(NSURL *)videoUrl
                              succeed:(void(^)())successBlock
                                 fail:(void(^)(NSError *error))errorBlock{
    
    //获取所有的系统创建的相册
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:[PHFetchOptions new]];
    //遍历相册，找到自己想要的那个
    if(collections!=nil && collections.count!=0) {
            
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //请求创建一个AssetChangeRequest
            [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl];

        } completionHandler:^(BOOL success, NSError *error) {
            if(success) {
                
                if(successBlock)
                    successBlock();
                
            } else {
                
                if(errorBlock)
                    errorBlock(error);
            }
        }];
        
    } else {
    
        
        NSError* error = [NSError errorWithDomain:@"没有该相册"
                                             code:kNoAlbumCode
                                         userInfo:@{NSLocalizedDescriptionKey:@"没有该相册"}];
        if(errorBlock) {
            errorBlock(error);
        }

    }
}

//save image or video to selected album
+ (void)saveImageWithImage:(UIImage *)image
      toAlbumWithAlbumName:(NSString *)albumName
                   succeed:(void(^)())successBlock
                      fail:(void(^)(NSError *error))errorBlock{

    __block BOOL haveFoundAlbum=NO;
    __block BOOL createRequestSuccess=NO;
    
    //获取所有的系统创建的相册
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]];
    //遍历相册，找到自己想要的那个
    for(PHAssetCollection* collection in collections) {
        NSLog(@"%@", collection.localizedTitle);
        if ([collection.localizedTitle isEqualToString:albumName]) {
            
            haveFoundAlbum=YES;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个AssetChangeRequest
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset ];
                
                if(placeHolder) {
                    //相册中添加视频
                    createRequestSuccess=YES;
                    [collectonRequest addAssets:@[placeHolder]];
                } else {
                    
                    if(errorBlock) {
                        
                        NSError* error = [NSError errorWithDomain:@"创建编辑相册请求失败(iOS8)"
                                                             code:kCreateRequestFail
                                                         userInfo:@{NSLocalizedDescriptionKey:@"创建编辑相册请求失败(iOS8)"}];
                        
                        errorBlock(error);
                    }
                }
                
            } completionHandler:^(BOOL success, NSError *error) {
                
                if(createRequestSuccess==NO) {
                    return;
                }
                
                if(success) {
                    
                    if(successBlock)
                        successBlock();
                    
                } else {
                    
                    if(errorBlock)
                        errorBlock(error);
                }
            }];
        }
        
    }

    if (haveFoundAlbum==NO) {
        
        NSError* error = [NSError errorWithDomain:@"没有该相册"
                                             code:kNoAlbumCode
                                         userInfo:@{NSLocalizedDescriptionKey:@"没有该相册"}];
        if(errorBlock) {
            errorBlock(error);
        }
    }
}

+ (void)saveVideoWithUrl:(NSURL *)videoUrl
    toAlbumWithAlbumName:(NSString *)albumName
                 succeed:(void(^)())successBlock
                    fail:(void(^)(NSError *error))errorBlock{
    
    __block BOOL haveFoundAlbum=NO;
    __block BOOL createRequestSuccess=NO;
    //获取所有的系统创建的相册
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]];
    //遍历相册，找到自己想要的那个
    for(PHAssetCollection* collection in collections) {
        DLog(@"%@", collection.localizedTitle);
        if ([collection.localizedTitle isEqualToString:albumName]) {
            
            haveFoundAlbum=YES;
            
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个AssetChangeRequest
                PHAssetChangeRequest *assetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoUrl];
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                
                if(placeHolder) {
                    //相册中添加视频
                    createRequestSuccess=YES;
                    [collectonRequest addAssets:@[placeHolder]];
                } else {
                 
                    if(errorBlock) {
                        
                        NSError* error = [NSError errorWithDomain:@"创建编辑相册请求失败"
                                                             code:kCreateRequestFail
                                                         userInfo:@{NSLocalizedDescriptionKey:@"创建编辑相册请求失败"}];
                        
                        errorBlock(error);
                    }
                }
                
            } completionHandler:^(BOOL success, NSError *error) {
                
                if(createRequestSuccess==NO) {
                    return;
                }
                    
                if(success) {
                    
                    if(successBlock)
                        successBlock();
                    
                } else {
                    
                    if(errorBlock)
                        errorBlock(error);
                }
        
            }];
        }
        
    }
    
    if (haveFoundAlbum==NO) {
        
        NSError* error = [NSError errorWithDomain:@"没有该相册"
                                             code:kNoAlbumCode
                                         userInfo:@{NSLocalizedDescriptionKey:@"没有该相册"}];
        
        if(errorBlock) {
            errorBlock(error);
        }
        
    }

}


//create album
+ (void)createAlbumWithAlbumName:(NSString *)AlbumName
                         succeed:(void(^)())successBlock
                            fail:(void(^)(NSError *error))errorBlock{
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:AlbumName];
    } completionHandler:^(BOOL success, NSError *error) {
        
        if(success) {
            
            if(successBlock)
                successBlock();
            
        } else {
            
            if(errorBlock)
                errorBlock(error);
        }
    }];
}

+ (void)isAlbumExistWithName:(NSString*)albumName
               completeBlock:(void(^)(BOOL isExist))completeBlock {
    
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]];
    //遍历相册，找到自己想要的那个
    for(PHAssetCollection* collection in collections) {
        
        if([collection.localizedTitle isEqualToString:albumName]) {
            
            if(completeBlock) {
                completeBlock(YES);
            }
            return;
        }
    }
    
    if(completeBlock) {
        completeBlock(NO);
    }
}
//rename album
+ (void)changeAlbumNameFrom:(NSString *)oldName to:(NSString *)newName {
    
}

//delete album
+ (void)deleteAlbumWithName:(NSString *)albumName {
    //获取自己创建的那些个相册
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [topLevelUserCollections enumerateObjectsUsingBlock:^(PHCollection *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"----%@", obj.localizedTitle);
        if ([obj.localizedTitle isEqualToString:albumName]) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                NSArray *arr = @[obj];
                [PHAssetCollectionChangeRequest deleteAssetCollections:arr];
            } completionHandler:^(BOOL success, NSError *error) {
                NSLog(@"%@", success ? @"success" : error.localizedDescription);
                *stop = YES;
            }];
        }
    }];

}

+ (void)dealIsHaveAuthorizationRight:(void(^)(BOOL isHaveRight,NSError *error))completeBlock {

    PHAuthorizationStatus authorizationStatus=[PHPhotoLibrary authorizationStatus];
    if(authorizationStatus==PHAuthorizationStatusRestricted||authorizationStatus==PHAuthorizationStatusDenied) {
        
        NSError* error = [NSError errorWithDomain:@"没有权限访问相册"
                                             code:kHaveNoRight
                                         userInfo:@{NSLocalizedDescriptionKey:@"没有权限访问相册"}];
        
        if(completeBlock) {
            completeBlock(NO,error);
        }
        
    } else {
        
        if(authorizationStatus==PHAuthorizationStatusNotDetermined) {
            //请求权限
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if(status==PHAuthorizationStatusAuthorized) {
                    
                    if(completeBlock) {
                        completeBlock(YES,nil);
                    }
                } else {
                    if(completeBlock) {
                        completeBlock(NO,nil);
                    }
                }
            }];
            
        } else {
            if(completeBlock) {
                completeBlock(YES,nil);
            }
        }
    }
}
@end
