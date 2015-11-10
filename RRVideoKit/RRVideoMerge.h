//
//  RRVideoMerge.h
//  RRVideoKit
//
//  Created by Remi Robert on 10/11/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RRVideoMerge : NSObject

@end


/*
 let composition = AVMutableComposition()
 let track = composition.addMutableTrackWithMediaType(  , preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
 var index = 0
 
 for currentVideoObject in sourceVideos {
 
 let urlVideo = NSURL(fileURLWithPath:currentVideoObject.absoluteString.componentsSeparatedByString("file://").last!)
 let videoAsset = AVAsset(URL: urlVideo)
 if index == 0 {
 
 do {
 try track.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo).first! as AVAssetTrack, atTime: kCMTimeZero)
 }
 catch {
 print("error insert at time")
 return
 }
 
 } else {
 do {
 try track.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo).first! as AVAssetTrack, atTime: composition.duration)
 }
 catch {
 print("error insert at time")
 return
 }
 }
 index++
 }
*/