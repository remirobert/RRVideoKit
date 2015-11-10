//
//  RRVideo.h
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RRVideoKit.h"

typedef enum : NSInteger {
    RRVideoSpeedFrameSlow = 8,
    RRVideoSpeedFrameNormal = 5,
    RRVideoSpeedFrameFast = 2,
} RRVideoSpeedFrame;

typedef enum : NSInteger {
    RRVideoRepeatFrameX1 = 1,
    RRVideoRepeatFrameX3 = 3,
    RRVideoRepeatFrameX6 = 6,
    RRVideoRepeatFrameX12 = 12,
} RRVideoRepeatFrame;


@interface RRVideo : NSObject

@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, assign) RRVideoSpeedFrame speedFrame;
@property (nonatomic, assign) RRVideoRepeatFrame repeatFrame;
@property (nonatomic, assign) BOOL mirroirFrame;

@property (nonatomic, assign) CGSize sizeVideo;
@property (nonatomic, assign) NSString *videoFile;

- (instancetype)init;
- (instancetype)initWithFrames:(NSArray *)images;

- (BFTask *)writeVideo;

@end
