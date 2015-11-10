//
//  RRVideoChunck+Initialize.m
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import "RRVideoChunck+Initialize.h"
#import "RRVideo.h"

@implementation RRVideoChunck (Initialize)

+ (NSArray *)initializeChuncks:(RRVideo *)video framesChunck:(NSInteger)framePerChunck {
    NSMutableArray *arrayChunks = [NSMutableArray array];
    
    NSInteger currentIndexChunck = 0;
    while (currentIndexChunck < video.frames.count) {
        NSMutableArray *currentChunck = [NSMutableArray array];
        for (NSInteger indexFrame = 0; indexFrame < framePerChunck; indexFrame++) {
            if (currentIndexChunck < video.frames.count) {
                [currentChunck addObject:@(currentIndexChunck)];
            }
            else {
                break;
            }
        }
        RRVideoChunck *newChunck = [RRVideoChunck new];
        newChunck.framesIndex = arrayChunks;
        [arrayChunks addObject:newChunck];
    }
    return arrayChunks;
}

@end
