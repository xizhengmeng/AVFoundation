//
//  ReaderAndWriterVC.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/9.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "ReaderAndWriterVC.h"
#import "ReaderAndWriter.h"

@interface ReaderAndWriterVC()
@property (nonatomic, strong) UIButton *readBtn;
@property (nonatomic, strong) ReaderAndWriter *readerAndWriter;
@end

@implementation ReaderAndWriterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.readBtn];
    self.readBtn.x = 100;
    self.readBtn.y = 100;
    
}

- (UIButton *)readBtn {
    if (!_readBtn) {
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readBtn setTitle:@"开始读" forState:UIControlStateNormal];
        [_readBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_readBtn addTarget:self action:@selector(startToRead) forControlEvents:UIControlEventTouchUpInside];
        [_readBtn sizeToFit];
    }
    return _readBtn;
}

- (void)startToRead {
    self.readerAndWriter = [[ReaderAndWriter alloc] init];
    [self.readerAndWriter readAndWrite];
}

@end
