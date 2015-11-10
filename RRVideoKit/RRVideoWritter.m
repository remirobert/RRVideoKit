//
//  RRVideoWritter.m
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import "RRVideoWritter.h"
#import "RRVideoKit.h"

@implementation RRVideoWritter

- (NSString *)path:(NSString *)fileName {
    NSString *documentsDirectory = [FCFileManager pathForDocumentsDirectory];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
    return filePath;
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image image:(UIImage *)img {
    int height = img.size.height;
    int width = img.size.width;
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, width,
                                          height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata, width,
                                                 height, 8, 4*width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}

- (BFTask *)writeImageAsMovie:(RRVideo *)video currentChunck:(RRVideoChunck *)chunck toPath:(NSString *)path {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    __block CVPixelBufferRef buffer = NULL;
    __block NSArray *frames = [chunck frames:video];
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path]
                                                           fileType:AVFileTypeQuickTimeMovie
                                                              error:nil];
    
    
    NSParameterAssert(videoWriter);
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:video.sizeVideo.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:video.sizeVideo.height], AVVideoHeightKey,
                                   nil];
    
    AVAssetWriterInput* writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                         outputSettings:videoSettings];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                                                                                     sourcePixelBufferAttributes:nil];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    [videoWriter addInput:writerInput];
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    __block NSInteger currentIndexFrame = 0;

    __block dispatch_queue_t backgroundQueue = dispatch_queue_create("com.rrvideokit.write", NULL);
    dispatch_async(backgroundQueue, ^(void) {
        BOOL writtingLoop = true;
        while (writerInput) {
            
            if (writerInput.readyForMoreMediaData) {
                CMTime frameTime = CMTimeMake(0, 600);
                double timer = 0.5;
                
                CMTime lastTime=CMTimeMake(currentIndexFrame * 60 * (timer * 10), 600);
                CMTime presentTime=CMTimeAdd(lastTime, frameTime);
                
                if (currentIndexFrame == 0) {
                    presentTime = CMTimeMake(0, 600);
                }
                
                if (currentIndexFrame >= [frames count]) {
                    CVPixelBufferRelease(buffer);
                    buffer = NULL;
                }
                else {
                    CVPixelBufferRelease(buffer);
                    UIImage *currentImage = [frames objectAtIndex:currentIndexFrame];
                    buffer = [self pixelBufferFromCGImage:[currentImage CGImage] image:currentImage];
                }
                
                if (buffer) {
                    [adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
                    currentIndexFrame++;
                }
                else {
                    writtingLoop = false;
                    [writerInput markAsFinished];
                    
                    [videoWriter finishWritingWithCompletionHandler:^{
                        NSString *finalPath;
                        if (videoWriter.status != AVAssetWriterStatusFailed && videoWriter.status == AVAssetWriterStatusCompleted) {
                            finalPath = path;
                        }
                        else {
                            finalPath = nil;
                        }
                        CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
                        CVPixelBufferRelease(buffer);
                        [task setResult:finalPath];
                        return;
                    }];
                }
            }
        }
    });
    return task.task;
}

- (BFTask *)writteVideo:(RRVideo *)video currentChunck:(RRVideoChunck *)chunck {
    BFTaskCompletionSource *taskCompletion = [BFTaskCompletionSource taskCompletionSource];
    
    NSString *path = [self path:chunck.chunckName];
    [FCFileManager removeItemAtPath:path];
    
    [[self writeImageAsMovie:video currentChunck:chunck toPath:path] continueWithSuccessBlock:^id(BFTask *task) {
        NSString *path = (NSString *)task.result;
        [taskCompletion setResult:[NSURL URLWithString:path]];
        return nil;
    }];
    return taskCompletion.task;
}

@end
