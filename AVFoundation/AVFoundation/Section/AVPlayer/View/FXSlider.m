//
//  FXSlider.m
//  AVF
//
//  Created by han on 16/1/1.
//  Copyright © 2016年 shenghuihan. All rights reserved.
//

#import "FXSlider.h"

@implementation FXSlider
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    CGRect rectNew = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    rectNew.origin.y = rect.origin.y - 20;
    rectNew.size.height = rect.size.height + 40;
    rectNew.origin.x = rectNew.origin.x - 20;
    rectNew.size.width = rectNew.size.width + 40;
    
    return rectNew;
}
@end
