//
//  RRVideoChunck.m
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import "RRVideoChunck.h"
#import "RRVideoKit.h"

@implementation RRVideoChunck

- (NSArray *)frames:(RRVideo *)video {
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSNumber *currentIndex in self.framesIndex) {
        NSInteger index = [currentIndex integerValue];
        if (index < video.frames.count) {
            [array addObject:[video.frames objectAtIndex:index]];
        }
        else {
            break;
        }
    }
    return array;
}

@end
