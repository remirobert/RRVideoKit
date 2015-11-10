//
//  RRVideoMerge.h
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RRVideoKit.h"

@interface RRVideoMerge : NSObject

+ (BFTask *)mergeVideo:(NSArray *)urls nameFile:(NSString *)nameFile;

@end