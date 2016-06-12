//
//  ReaderAndWriter.m
//  AVFoundation
//
//  Created by shenghuihan on 16/6/9.
//  Copyright © 2016年 han1. All rights reserved.
//

#import "ReaderAndWriter.h"

@interface ReaderAndWriter()
@property (nonatomic, strong) AVAssetReader *reader;
@property (nonatomic, strong) AVAssetWriter *writer;
@end

@implementation ReaderAndWriter

- (void)readAndWrite {
    //创建reader
    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    //要使用avurlasst不能使avasset用
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    CMTime duration = asset.duration;
//    AVAsset *asset = [AVAsset assetWithURL:url];
    
    NSLog(@"----%@", [asset tracksWithMediaType:AVMediaTypeVideo]);
    
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    NSError *error;
    
    self.reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    
    NSDictionary *readerSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
    
    AVAssetReaderTrackOutput *trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:track outputSettings:readerSettings];
    
    [self.reader addOutput:trackOutput];
    
    [self.reader startReading];
    
    
    //创建writer
    //这里只能用fileurl...不可以使用urlwith
    NSURL *outputUrl = [NSURL fileURLWithPath:@"/Users/han/Desktop/output/demo.mp4"];
    self.writer  =[[AVAssetWriter alloc] initWithURL:outputUrl fileType:AVFileTypeQuickTimeMovie error:nil];
    
    NSDictionary *writeSetting = @{
                                   AVVideoCodecKey : AVVideoCodecH264,
                                   AVVideoHeightKey : @1280,
                                   AVVideoWidthKey : @720,
                                   AVVideoCompressionPropertiesKey : @{
                                           AVVideoMaxKeyFrameIntervalKey : @1,
                                           AVVideoAverageBitRateKey :@10500000,
                                           AVVideoProfileLevelKey : AVVideoProfileLevelH264Main31,
                                           },
                                   };
    
    AVAssetWriterInput *writeInput = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:writeSetting];
    
    [self.writer addInput:writeInput];
    
    [self.writer startWriting];
    
    //开启会话，将读到的数据写入
    dispatch_queue_t dispatchQueue = dispatch_queue_create("write", NULL);
    [self.writer startSessionAtSourceTime:kCMTimeZero];
    
//    CMTime endTime = CMTimeMake(6188, duration.timescale);
//    [self.writer endSessionAtSourceTime:endTime];
    
    [writeInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        BOOL complete = NO;
        while ([writeInput isReadyForMoreMediaData] && !complete) {
            CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];
            
            if (sampleBuffer) {
                BOOL result = [writeInput appendSampleBuffer:sampleBuffer];
                CFRelease(sampleBuffer);
                complete = !result;
            }else {
                [writeInput markAsFinished];
                complete = YES;
            }
        }
        
        if (complete) {
            [self.writer finishWritingWithCompletionHandler:^{
                AVAssetWriterStatus status = self.writer.status;
                if (status == AVAssetWriterStatusCompleted) {
                    NSLog(@"写入成功%@", outputUrl);
                }else {
                    NSLog(@"写入失败");
                }
            }];
        }
        
    }];
}

@end
