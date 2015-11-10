//
//  ViewController.m
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import "ViewController.h"
#import "RRVideo.h"
#import "UIImage+Resize.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    UIImage *img1 = [[UIImage imageNamed:@"1"] resizedImageToSize:CGSizeMake(480, 480)];
    UIImage *img2 = [[UIImage imageNamed:@"2"] resizedImageToSize:CGSizeMake(480, 480)];;
    UIImage *img3 = [[UIImage imageNamed:@"3"] resizedImageToSize:CGSizeMake(480, 480)];;
    
    NSArray *images = @[img1, img2, img3, img1, img2, img3,img1, img2, img3];
    
    RRVideo *video = [[RRVideo alloc] initWithFrames:images];
    [[video writeVideo] continueWithSuccessBlock:^id(BFTask *task) {
        
        NSLog(@"tasks results : %@", task.result);
        return nil;
    }];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
