//
//  RRVideoMerge.m
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import "RRVideoMerge.h"
#import "RRVideoKit.h"

@implementation RRVideoMerge

+ (BFTask *)mergeVideo:(NSArray *)urls nameFile:(NSString *)nameFile {
    BFTaskCompletionSource *taskCompletion = [BFTaskCompletionSource taskCompletionSource];
    __block NSInteger index = 0;
    __block dispatch_queue_t backgroundQueue = dispatch_queue_create("com.rrvideokit.merge", NULL);
    
    dispatch_async(backgroundQueue, ^(void) {
        AVMutableComposition *composition = [AVMutableComposition new];
        AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        for (NSURL *currentVideoUrl in urls) {
            
            if (![FCFileManager existsItemAtPath:[currentVideoUrl absoluteString]]) {
                [taskCompletion setResult:nil];
            }
            
            AVAsset *asset = [AVAsset assetWithURL:currentVideoUrl];
            AVAssetTrack *currentTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
                        
            if (index) {
                [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:currentTrack atTime:kCMTimeZero error:nil];
            }
            else {
                [track insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:currentTrack atTime:kCMTimeZero error:nil];
            }
            index++;
        }
        
        NSString *path = [[FCFileManager pathForDocumentsDirectory] stringByAppendingPathComponent:nameFile];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetHighestQuality];
        exporter.outputURL = [NSURL URLWithString:path];
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = true;

        [exporter exportAsynchronouslyWithCompletionHandler:^{
            [taskCompletion setResult:path];
        }];
    });
    return taskCompletion.task;
}

@end
