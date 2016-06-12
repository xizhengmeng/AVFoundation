//
//  CollectionShowCell.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/8.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "CollectionShowCell.h"

@interface CollectionShowCell()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CollectionShowCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.imageView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.size = self.size;
}

- (void)reloadImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end
