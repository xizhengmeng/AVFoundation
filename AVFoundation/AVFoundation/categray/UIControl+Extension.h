//
//  UIControl+Extension.h
//  button
//
//  Created by han on 15/11/30.
//  Copyright © 2015年 han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Extension)
//扩大按钮的点击范围
- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end
