//
//  VoiceRecorder.h
//  AVFoundation
//
//  Created by shenghuihan on 16/6/5.
//  Copyright © 2016年 han1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^THRecordingStopCompletionHandler) (BOOL);
typedef void(^THRecordingSaveCompletionHandler) (BOOL);

@interface VoiceRecorder : NSObject

- (void)record;
- (void)pause;
- (void)stopwithCompletionHander:(THRecordingSaveCompletionHandler)handler;
- (void)saveRecorderWithName:(NSString *)name andCompletionHandler:(THRecordingSaveCompletionHandler)handler;

@end
