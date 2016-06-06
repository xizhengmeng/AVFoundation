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
@property (nonatomic, copy) THRecordingStopCompletionHandler completeHandler;
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

#pragma mark - delegate
//完成录制回调
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (self.completeHandler) {
        self.completeHandler(flag);
    }
}

#pragma mark - lazyload

- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        
        NSString *fileName = @"demo.caf";
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [path stringByAppendingString:fileName];
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

- (void)stopwithCompletionHander:(THRecordingSaveCompletionHandler)handler {
    self.completeHandler = handler;
    [self.recorder stop];
}

- (void)saveRecorderWithName:(NSString *)name andCompletionHandler:(THRecordingSaveCompletionHandler)handler {
    NSTimeInterval timestamp = [NSDate timeIntervalSinceReferenceDate];
    NSString *fileName = [NSString stringWithFormat:@"/%@-%f.caf", name, timestamp];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destPath = [path stringByAppendingString:fileName];
    
    NSURL *srcUrl = self.recorder.url;
    NSURL *destUrl = [NSURL fileURLWithPath:destPath];
    
    NSData *recorderFile = [NSData dataWithContentsOfURL:srcUrl];
    
    NSError *error;
    
    BOOL success = [[NSFileManager defaultManager] createFileAtPath:destPath contents:recorderFile attributes:nil];
    
    
//    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:srcUrl toURL:destUrl error:&error];
    //之所以放弃这个方法是因为有错误`you don't have permission to access ....`
    if (success) {
        handler(YES);
        [self.recorder prepareToRecord];
        NSLog(@"success--%@", destUrl);
    }else {
        handler(NO);
        NSLog(@"fial--%@", error.localizedDescription);
    }
    
}
@end
