//
//  NSURL+Video.m
//  DavidVideo
//
//  Created by Test on 14-9-7.
//  Copyright (c) 2014年 Test. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NSURL+Video.h"
#import "LJXDebug.h"



@implementation NSURL (Video)
-(void)imageAtTime:(NSTimeInterval)time size:(CGSize)size completion:(void(^)(UIImage* image, NSError* error))completion
{
    __block BOOL done = NO;
//    while (!done) {
//        
//    }
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self options:nil];
    __block AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;;
    generator.maximumSize = size;
    CMTime thumbTime = CMTimeMakeWithSeconds(0, time);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        done = YES;
        if (error) {
            LJXNSError(error);
            if (completion) {
                completion(nil, error);
            }
        }
        if (completion) {
            completion([UIImage imageWithCGImage:im], error);
        }
        generator = nil;
    };
    
    CGSize maxSize = CGSizeMake(320, 180);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
}

@end
