//
//  RRVideo.m
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import "RRVideo.h"

@interface RRVideo ()
@property (nonatomic, strong) RRVideoWritter *videoWritter;
@property (nonatomic, strong) NSMutableArray *urlsChunckVideo;
@end

@implementation RRVideo

- (instancetype)init {
    self = [super init];

    if (self) {
        self.videoWritter = [RRVideoWritter new];
        self.frames = [NSMutableArray array];
        self.speedFrame = RRVideoSpeedFrameNormal;
        self.repeatFrame = RRVideoRepeatFrameX1;
        self.mirroirFrame = false;
        self.sizeVideo = CGSizeMake(480, 480);
        self.videoFile = @"tmp.mov";
    }
    return self;
}

- (instancetype)initWithFrames:(NSArray * _Nonnull)images {
    self = [self init];
    
    if (self) {
        [self.frames addObjectsFromArray:images];
    }
    return self;
}

- (BFTask *)writeVideo {
    BFTaskCompletionSource *taskCompletion = [BFTaskCompletionSource taskCompletionSource];

    self.urlsChunckVideo = [NSMutableArray array];
    __block NSArray *tasks = @[[self.videoWritter writteVideo:self], [self.videoWritter writteVideo:self], [self.videoWritter writteVideo:self]];

    [[BFTask taskForCompletionOfAllTasksWithResults:tasks] continueWithBlock:^id(BFTask *task) {
        self.urlsChunckVideo = task.result;
        
        
        // merge and result the final URL
        [taskCompletion setResult:task.result];
        return nil;
    }];
    return taskCompletion.task;
}

@end
