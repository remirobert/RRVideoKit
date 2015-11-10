//
//  RRVideoChunck+Initialize.m
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import "RRVideoChunck+Initialize.h"
#import "RRVideo.h"
#import "RRVideoKit.h"

@implementation RRVideoChunck (Initialize)

+ (NSArray *)initializeChuncks:(RRVideo *)video framesChunck:(NSInteger)framePerChunck {
    NSMutableArray *arrayChunks = [NSMutableArray array];
    
    NSInteger currentIndexChunck = 0;
    while (currentIndexChunck < video.frames.count) {
        NSMutableArray *currentChunck = [NSMutableArray array];
        for (NSInteger indexFrame = 0; indexFrame < framePerChunck; indexFrame++) {
            if (currentIndexChunck < video.frames.count) {
                [currentChunck addObject:@(currentIndexChunck)];
                currentIndexChunck++;
            }
            else {
                break;
            }
        }
        
        RRVideoChunck *newChunck = [RRVideoChunck new];
        newChunck.framesIndex = currentChunck;
        newChunck.chunckName = [NSString stringWithFormat:@"chunck%ld.mov", currentIndexChunck];
        newChunck.video = video;
        [arrayChunks addObject:newChunck];
    }
    return arrayChunks;
}

+ (void)cleanChunckfiles:(NSArray *)chuncks {
    for (RRVideoChunck *currentChunck in chuncks) {
        NSString *filePath = [[FCFileManager pathForDocumentsDirectory] stringByAppendingPathComponent:currentChunck.chunckName];
        [FCFileManager removeItemAtPath:filePath];
    }
}

@end
