//
//  UIView+Metrics.m
//  NeeFrame
//
//  Created by ganvin   on 14-4-14.
//  Copyright (c) 2014年 ganvin. All rights reserved.
//

#import "UIView+Metrics.h"
#import "UIColor+Addition.h"
#define StatusView_Tag 90800378
@class CallBackBtn;

@implementation UIView (Metrics)

@dynamic top;
@dynamic bottom;
@dynamic left;
@dynamic right;

@dynamic width;
@dynamic height;

@dynamic offset;
@dynamic position;
@dynamic size;

@dynamic x;
@dynamic y;
@dynamic w;
@dynamic h;

- (CGFloat)top
{
	return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
	CGRect frame = self.frame;
	frame.origin.y = top;
	self.frame = frame;
}

- (CGFloat)left
{
	return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
	CGRect frame = self.frame;
	frame.origin.x = left;
	self.frame = frame;
}

- (CGFloat)width
{
	return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)height
{
	return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
	self.frame = frame;
}

- (CGFloat)x
{ 
	return self.frame.origin.x;
}

- (void)setX:(CGFloat)value
{
	CGRect frame = self.frame;
	frame.origin.x = value;
	self.frame = frame;
}

- (CGFloat)y
{
	return self.frame.origin.y;
}

- (void)setY:(CGFloat)value
{
	CGRect frame = self.frame;
	frame.origin.y = value;
	self.frame = frame;
}

- (CGFloat)w
{
	return self.frame.size.width;
}

- (void)setW:(CGFloat)width
{
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)h
{
	return self.frame.size.height;
}

- (void)setH:(CGFloat)height
{
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (CGPoint)offset
{
	CGPoint		point = CGPointZero;
	UIView *	view = self;
    
	while ( view )
	{
		point.x += view.frame.origin.x;
		point.y += view.frame.origin.y;
		
		view = view.superview;
	}
	
	return point;
}

- (void)setOffset:(CGPoint)offset
{
	UIView * view = self;
	if ( nil == view )
		return;
    
	CGPoint point = offset;
    
	while ( view )
	{
		point.x += view.superview.frame.origin.x;
		point.y += view.superview.frame.origin.y;
        
		view = view.superview;
	}
    
    CGRect frame = self.frame;
	frame.origin = point;
	self.frame = frame;
}

- (CGPoint)position
{
	return self.frame.origin;
}

- (void)setPosition:(CGPoint)pos
{
    CGRect frame = self.frame;
	frame.origin = pos;
	self.frame = frame;
}

- (CGSize)size
{
	return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)boundsCenter
{
    return CGPointMake( CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) );
}


- (void)showTxtStatusView:(NSString *)txtStauts{
    [self dismissStatusView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithHexString:@"#8D8D8D"];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    label.text = txtStauts;
    label.tag = StatusView_Tag+1;
    [self addSubview:label];
    
    
}


- (void)showStatusViewWithTitle:(NSString *)title callBack:(void(^)(void))callBack{
    [self dismissStatusView];
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.tag = StatusView_Tag;
    backView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight;
    backView.backgroundColor = [UIColor clearColor];
    CGFloat height = self.width >= 320?self.width*210/640:105;
    UIView *centerView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.height - height)/2.0f - 10, self.width, height)];
    centerView.backgroundColor = [UIColor clearColor];
    CGFloat imgHeight = height*130/210;
    CGFloat imgWidth = imgHeight*94/130;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((centerView.width - imgWidth)/2.0f, 0, imgWidth, imgHeight)];
    imageView.image = [UIImage imageNamed:@"fx_icon_status"];
    [centerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom, centerView.width, centerView.height - imageView.bottom)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor colorWithHexString:@"#8D8D8D"];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.text = title;
    [centerView addSubview:label];
    
    [backView addSubview:centerView];
    
    CallBackBtn *btn = [CallBackBtn buttonWithType:UIButtonTypeCustom];
    btn.frame = backView.bounds;
    btn.callBackHandler = callBack;
    [btn addTarget:self action:@selector(callBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    [self addSubview:backView];
    
    
}
- (void)dismissStatusView{
    [[self viewWithTag:StatusView_Tag] removeFromSuperview];
    [[self viewWithTag:StatusView_Tag+1] removeFromSuperview];
}
- (void)callBackBtnClick:(CallBackBtn *)sender{
    if (sender.callBackHandler) {
        sender.callBackHandler();
    }
    //    UIView *statusView = [self viewWithTag:StatusView_Tag];
    //    if (statusView) {
    //        [statusView removeFromSuperview];
    //    }
    
}
@end

@implementation CallBackBtn


@end
