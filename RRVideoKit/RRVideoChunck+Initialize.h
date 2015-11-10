//
//  RRVideoChunck+Initialize.h
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import "RRVideoChunck.h"

@interface RRVideoChunck (Initialize)

+ (NSArray *)initializeChuncks:(id)video framesChunck:(NSInteger)framePerChunck;
+ (void)cleanChunckfiles:(NSArray *)chuncks;

@end
