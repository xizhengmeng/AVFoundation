//
//  SpeechSynthesizer.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/5.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "SpeechSynthesizer.h"
#import <AVFoundation/AVFoundation.h>
#define CELL @"cell"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
@interface SpeechSynthesizer()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIButton *speederBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UIView *textFiledBackView;
@property (nonatomic, strong) UIButton *sendBtn;
@end
@implementation SpeechSynthesizer

- (UIButton *)speederBtn {
    if (!_speederBtn) {
        _speederBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speederBtn setTitle:@"speeder" forState:UIControlStateNormal];
        [_speederBtn addTarget:self action:@selector(speeker) forControlEvents:UIControlEventTouchUpInside];
        _speederBtn.backgroundColor = [UIColor orangeColor];
        [_speederBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_speederBtn sizeToFit];
    }
    return _speederBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.textFiledBackView];
    self.textFiledBackView.bottom = kScreenH;
    
    
}

- (void)speeker {
   
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Hello Wolrd"];
    [synthesizer speakUtterance:utterance];
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CELL];
    cell.backgroundColor = [UIColor clearColor];
    //code
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma lazyload
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate  = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL];
        _tableView.height = kScreenH - 60;
//        _tableView.y = 64;
        _tableView.backgroundColor = [UIColor orangeColor];
    }
    return _tableView;
}

- (UITextField *)textfield {
    if (!_textfield) {
        _textfield = [[UITextField alloc] init];
        _textfield.size = CGSizeMake(kScreenW - 80, 50);
        _textfield.backgroundColor = [UIColor blueColor];
        _textfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textfield.layer.borderWidth = 1;
        _textfield.layer.cornerRadius = 5;
    }
    return _textfield;
}

- (UIView *)textFiledBackView {
    if (!_textFiledBackView) {
        _textFiledBackView = [[UIView alloc] init];
        _textFiledBackView.size = CGSizeMake(kScreenW, 60);
        [_textFiledBackView addSubview:self.textfield];
        _textFiledBackView.backgroundColor = [UIColor whiteColor];
        self.textfield.x = 10;
        self.textfield.centerY = 30;
    }
    return _textFiledBackView;
}

- (void)keyboardWillShow:(NSNotification *)noti {
    WEAKSELF;
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat keyboardY = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat ty = keyboardY - kScreenH;
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.textFiledBackView.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.textfield resignFirstResponder];
}

- <#name#> {
    if (!_<#name#>) {
        _<#name#> = [];
    }
    return _<#name#>;
}

- (void)setSendBtn:(UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _sendBtn;
}
@end
