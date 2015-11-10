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

+ (BFTask *)mergeVideo:(NSArray *)urls {
    BFTaskCompletionSource *taskCompletion = [BFTaskCompletionSource taskCompletionSource];
    
    __block dispatch_queue_t backgroundQueue = dispatch_queue_create("com.rrvideokit.merge", NULL);
    dispatch_async(backgroundQueue, ^(void) {
        
        AVMutableComposition *composition = [AVMutableComposition new];
        AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        for (NSURL *currentVideoUrl in urls) {
            
        }
    });
    return taskCompletion.task;
}

@end
