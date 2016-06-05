//
//  SpeechSynthesizer.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/5.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "SpeechSynthesizer.h"
#import <AVFoundation/AVFoundation.h>
@implementation SpeechSynthesizer

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:@"Hello Wolrd"];
    [synthesizer speakUtterance:utterance];
}

@end
