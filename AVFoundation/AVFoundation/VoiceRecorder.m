//
//  VoiceRecorder.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/5.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "VoiceRecorder.h"

@interface VoiceRecorder()<AVAudioRecorderDelegate>
@property (nonatomic, strong) AVAudioRecorder *recorder;
@end

@implementation VoiceRecorder

- (instancetype)init {
    if (self = [super init]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *error;
        //打开录音功能
        if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]) {
            NSLog(@"category error:%@", error.localizedDescription);
        }
        
        if (![session setActive:YES error:&error]) {
            NSLog(@"activity error:%@", error.localizedDescription);
        }
        
        if (self.recorder) {
            self.recorder.delegate = self;
            [self.recorder prepareToRecord];
        }
    }
    return self;
}

#pragma mark - lazyload

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        
        NSString *tmpDir = NSTemporaryDirectory();
        NSString *filePath = [tmpDir stringByAppendingString:@"demo.caf"];
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
        
        NSDictionary *settings = @{
                                   AVFormatIDKey : @(kAudioFormatAppleIMA4),
                                   AVSampleRateKey : @44100.0f,
                                   AVNumberOfChannelsKey : @1,
                                   AVEncoderBitDepthHintKey : @16,
                                   AVEncoderAudioQualityKey : @(AVAudioQualityMedium)
                                   };
        
        NSError *error;
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:settings error:&error];
    
    }
    return _recorder;
}

- (void)record {
    [self.recorder record];
}

- (void)pause
{
    [self.recorder pause];
}

@end
