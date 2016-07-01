//
//  AssetLibraryManager.m
//  FanXing
//
//  Created by 洪锐堉 on 15/12/25.
//  Copyright © 2015年 han. All rights reserved.
//

#import "AssetLibraryManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AssetLibraryManager()

@property(nonatomic,strong) ALAssetsLibrary *assetsLibrary;

@end


@implementation AssetLibraryManager

static AssetLibraryManager *assetLibraryMgr;
+ (AssetLibraryManager *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        assetLibraryMgr = [[AssetLibraryManager alloc] init];
        
    });
    return assetLibraryMgr;
}

- (id)init {
    
    self=[super init];
    if(self) {
        
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    return self;
}

- (void)saveImageToSystemAlbumWithImage:(UIImage *)image
                                succeed:(void(^)())successBlock
                                   fail:(void(^)(NSError *error))errorBlock {
    
    __block BOOL isFoundAlbum=NO;
    
    WEAKSELF;
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        
        if(group) {
            
            isFoundAlbum=YES;
            *stop=YES;
            
            [weakSelf.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                
                if(error==nil) {
                    
                    [weakSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        
                        if(asset) {
                            [group addAsset:asset];
                            
                            if (successBlock) {
                                successBlock();
                            }
                        } else {
                            
                            if (errorBlock) {
                                NSError* assetError=[NSError errorWithDomain:@"创建asset失败"
                                                                        code:kCreateAssetFail
                                                                    userInfo:@{NSLocalizedDescriptionKey:@"创建asset失败"}];
                                errorBlock(assetError);
                            }
                        }
                        
                    } failureBlock:^(NSError *error) {
                        if (errorBlock) {
                            errorBlock(error);
                        }
                    }];
                } else {
                    
                    if (errorBlock) {
                        errorBlock(error);
                    }
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
        
    } failureBlock:^(NSError* error) {
        
        if(errorBlock) {
            errorBlock(error);
        }
    }];

    
}

- (void)saveVideoToSystemAlbumWithUrl:(NSURL *)videoUrl
                              succeed:(void(^)())successBlock
                                 fail:(void(^)(NSError *error))errorBlock {
    
    __block BOOL isFoundAlbum=NO;
    
    WEAKSELF;
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        
        if(group) {
            
            NSString *name =[group valueForProperty:ALAssetsGroupPropertyName];
            DLog(@"tosystem:%@",name);
            
            isFoundAlbum=YES;
            *stop=YES;

            [weakSelf.assetsLibrary writeVideoAtPathToSavedPhotosAlbum:videoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
                
                if(error==nil) {
                    
                    [weakSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        
                        if(asset) {
                            [group addAsset:asset];
                            
                            if (successBlock) {
                                successBlock();
                            }
                        } else {
                            
                            if (errorBlock) {
                                NSError* assetError=[NSError errorWithDomain:@"创建asset失败"
                                                                        code:kCreateAssetFail
                                                                    userInfo:@{NSLocalizedDescriptionKey:@"创建asset失败"}];
                                errorBlock(assetError);
                            }
                        }
                        
                    } failureBlock:^(NSError *error) {
                        if (errorBlock) {
                            errorBlock(error);
                        }
                    }];
                } else {
                    
                    if (errorBlock) {
                        errorBlock(error);
                    }
                }
                
                
            }];
            
        } else {
            
            if(isFoundAlbum==NO) {
                
                NSError* error = [NSError errorWithDomain:@"没有该相册"
                                                     code:kNoAlbumCode
                                                 userInfo:@{NSLocalizedDescriptionKey:@"没有该相册"}];
                
                if(errorBlock) {
                    errorBlock(error);
                }
            }
            
        }
        
    } failureBlock:^(NSError* error) {
        
        if(errorBlock) {
            errorBlock(error);
        }
        return;
    }];
    
}



- (void)saveImageWithImage:(UIImage *)image
      toAlbumWithAlbumName:(NSString *)albumName
                   succeed:(void(^)())successBlock
                      fail:(void(^)(NSError *error))errorBlock {
 
    __block BOOL isFoundAlbum=NO;
    
    WEAKSELF;
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        
        if(group) {
            
            NSString *name =[group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:albumName])
            {
                isFoundAlbum=YES;
                *stop=YES;
                
                [weakSelf.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                    
                    if(error==nil) {
                        
                        [weakSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                            
                            if(asset) {
                                [group addAsset:asset];
                                
                                if (successBlock) {
                                    successBlock();
                                }
                            } else {
                                
                                if (errorBlock) {
                                    NSError* assetError=[NSError errorWithDomain:@"创建asset失败"
                                                                            code:kCreateAssetFail
                                                                        userInfo:@{NSLocalizedDescriptionKey:@"创建asset失败"}];
                                    errorBlock(assetError);
                                }
                            }
                            
                        } failureBlock:^(NSError *error) {
                            if (errorBlock) {
                                errorBlock(error);
                            }
                        }];
                    } else {
                        
                        if (errorBlock) {
                            errorBlock(error);
                        }
                    }
                }];

            }
        } else {
            NSError* error = [NSError errorWithDomain:@"没有该相册"
                                                 code:kNoAlbumCode
                                             userInfo:@{NSLocalizedDescriptionKey:@"没有该相册"}];
            
            if(errorBlock) {
                errorBlock(error);
            }
        }
        
    } failureBlock:^(NSError* error) {
        
        if(errorBlock) {
            errorBlock(error);
        }
    }];

    
}

- (void)saveVideoWithUrl:(NSURL *)videoUrl
    toAlbumWithAlbumName:(NSString *)albumName
                 succeed:(void(^)())successBlock
                    fail:(void(^)(NSError *error))errorBlock {
    
    __block BOOL isFoundAlbum=NO;
    
    WEAKSELF;
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        
        if(group) {
            
            NSString *name =[group valueForProperty:ALAssetsGroupPropertyName];
            if ([name isEqualToString:albumName])
            {
                isFoundAlbum=YES;
                *stop=YES;
                
                [weakSelf.assetsLibrary writeVideoAtPathToSavedPhotosAlbum:videoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
                    
                    if(error==nil) {
                        
                        [weakSelf.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                            
                            if(asset) {
                                [group addAsset:asset];
                                
                                if (successBlock) {
                                    successBlock();
                                }
                            } else {
                                
                                if (errorBlock) {
                                    NSError* assetError=[NSError errorWithDomain:@"创建asset失败"
                                                                            code:kCreateAssetFail
                                                                        userInfo:@{NSLocalizedDescriptionKey:@"创建asset失败"}];
                                    errorBlock(assetError);
                                }
                            }
                            
                            
                        } failureBlock:^(NSError *error) {
                            if (errorBlock) {
                                errorBlock(error);
                            }
                        }];
                    } else {
                        
                        if (errorBlock) {
                            errorBlock(error);
                        }
                    }

                    
                }];
                
            }
        } else {
            
            if(isFoundAlbum==NO) {
                
                NSError* error = [NSError errorWithDomain:@"没有该相册"
                                                     code:kNoAlbumCode
                                                 userInfo:@{NSLocalizedDescriptionKey:@"没有该相册"}];
                
                if(errorBlock) {
                    errorBlock(error);
                }
            }
            
        }
        
    } failureBlock:^(NSError* error) {
        
        if(errorBlock) {
            errorBlock(error);
        }
        return;
    }];

}


- (void)createAlbumWithAlbumName:(NSString *)AlbumName
                         succeed:(void(^)())successBlock
                            fail:(void(^)(NSError *error))errorBlock {
    
    [self.assetsLibrary addAssetsGroupAlbumWithName:AlbumName
                                   resultBlock:^(ALAssetsGroup *group) {
        
                                       if(group) {
                                           if(successBlock) {
                                               successBlock();
                                           }
                                       } else {
                                           NSError* addError = [NSError errorWithDomain:@"添加相册失败,相册名已存在"
                                                                                   code:kHaveExistAlbumName
                                                                               userInfo:@{NSLocalizedDescriptionKey:@"添加相册失败,相册名已存在"}];
                                           
                                           if(errorBlock) {
                                               errorBlock(addError);
                                           }
                                       }
                                       
         
                                   } failureBlock:^(NSError* error) {
                                       if(errorBlock) {
                                           errorBlock(error);
                                       }
                                   }];

    
}


- (void)isAlbumExistWithName:(NSString*)albumName
               completeBlock:(void(^)(BOOL isExist))completeBlock{
    
    //创建相簿
    __block BOOL isFoundAlbum;
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        
        if(group) {
            NSString *name =[group valueForProperty:ALAssetsGroupPropertyName];
            DLog(@"name:%@,isStop:%@",name,*stop?@"YES":@"NO");
            if ([name isEqualToString:albumName])
            {
                isFoundAlbum=YES;
                *stop=YES;
                
                if(completeBlock) {
                    completeBlock(YES);
                }
                
                return;
            }
        } else {
            
            if(isFoundAlbum==NO) {
                if(completeBlock) {
                    completeBlock(NO);
                }
            }
        }
        
    } failureBlock:^(NSError* error) {
        
        if(completeBlock) {
            completeBlock(NO);
        }
        return;
    }];
    
}

- (void)dealIsHaveAuthorizationRight:(void(^)(BOOL isHaveRight,NSError *error))completeBlock{
    
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    if(authorizationStatus==ALAuthorizationStatusRestricted||authorizationStatus==ALAuthorizationStatusDenied) {
        
        NSError* error = [NSError errorWithDomain:@"没有权限访问相册"
                                                code:kHaveNoRight
                                            userInfo:@{NSLocalizedDescriptionKey:@"没有权限访问相册"}];
        
        if(completeBlock) { 
            completeBlock(NO,error);
        }
        
    } else {
        
        if(completeBlock) {
            completeBlock(YES,nil);
        }
    }
    
}


@end
