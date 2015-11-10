//
//  RRVideoChunck.h
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>

# define RRVideoKitDefaultNumberFramePerChunck      5

@interface RRVideoChunck : NSObject

@property (nonatomic, strong) NSMutableArray *framesIndex;

@end
