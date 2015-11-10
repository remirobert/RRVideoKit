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
@property (nonatomic, assign) NSInteger currentIndexChunck;
@property (nonatomic, strong) NSArray *chuncks;
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

- (NSArray *)tasks {
    NSMutableArray *tasksArray = [NSMutableArray array];
    for (RRVideoChunck *currentChunk in self.chuncks) {
        [tasksArray addObject:[self.videoWritter writteVideo:self currentChunck:currentChunk]];
    }
    return tasksArray;
}

- (BFTask *)writeVideo {
    BFTaskCompletionSource *taskCompletion = [BFTaskCompletionSource taskCompletionSource];

    self.urlsChunckVideo = [NSMutableArray array];
    self.videoWritter.video = self;
    self.currentIndexChunck = 0;
    self.chuncks = [RRVideoChunck initializeChuncks:self framesChunck:RRVideoKitDefaultNumberFramePerChunck];
    
    [[BFTask taskForCompletionOfAllTasksWithResults:[self tasks]] continueWithBlock:^id(BFTask *task) {
        self.urlsChunckVideo = task.result;
        
        [[RRVideoMerge mergeVideo:self.urlsChunckVideo nameFile:self.videoFile] continueWithSuccessBlock:^id(BFTask *task) {
            [taskCompletion setResult:task.result];
            return nil;
        }];
        return nil;
    }];
    return taskCompletion.task;
}

@end
