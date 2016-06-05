//
//  UIImage+Extension.h
//  UIImage分类
//
//  Created by shenghuihan on 13/11/15.
//  Copyright © 2013年 shenghuihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
//apply a image
- (UIImage *)applyDarkEffect;
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;
- (NSArray *)clipImageInScale:(CGFloat)scale;

//create an image by color
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color
               cornerRadius:(CGFloat)cornerRadius;

//scale the image
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

//scaleAspectfill use with the mode scaleaspectfill
+ (UIImage *)imageWithImageSimple:(UIImage *)image withImageViewSize:(CGSize)size;


//round an image
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;

//rotate the source image
- (UIImage *)imageByRotate:(CGFloat)radians fitSize:(BOOL)fitSize;
- (UIImage *)imageByRotateLeft90;
- (UIImage *)imageByRotateRight90;
- (UIImage *)imageByRotate180;
- (UIImage *)imageByFlipVertical;
- (UIImage *)imageByFlipHorizontal;
@end
