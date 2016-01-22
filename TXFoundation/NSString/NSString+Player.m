//
//  NSString+Player.m
//  iMove
//
//  Created by linjinxing on 14-8-12.
//  Copyright (c) 2014年 iMove. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "NSString+Player.h"
#import "NSObject+GCD.h"
#import "NSString+UrlAddition.h"
#import "NSStringAdditions.h"

@implementation NSString (Player)

-(BOOL)isExtendSystemSupportedVideoFormmat
{
    NSString* extension = self;
    return (
            NSOrderedSame == [extension caseInsensitiveCompare:@"mp4"]
            || NSOrderedSame == [extension caseInsensitiveCompare:@"mov"]
            || NSOrderedSame == [extension caseInsensitiveCompare:@"m4v"]
            || NSOrderedSame == [extension caseInsensitiveCompare:@"mpv"]
            //            || NSOrderedSame == [extension caseInsensitiveCompare:@"3gp"]
            );
}


-(BOOL)isSystemSupportedVideoFormmat
{
    NSString* extension = [self pathExtension];
    return (
            NSOrderedSame == [extension caseInsensitiveCompare:@"mp4"]
            || NSOrderedSame == [extension caseInsensitiveCompare:@"mov"]
            || NSOrderedSame == [extension caseInsensitiveCompare:@"m4v"]
            || NSOrderedSame == [extension caseInsensitiveCompare:@"mpv"]
            //            || NSOrderedSame == [extension caseInsensitiveCompare:@"3gp"]
            );
}

- (void)isSystemSupportedMovieFormmat:(LJXBoolBlock)playable
{
    NSURL* URL = nil;
    NSString* lowcaseURL = [self lowercaseString];
    if ( [lowcaseURL isiPodOrAssetURL]
        ||[lowcaseURL hasPrefix:@"http:"])
    {
        URL = [NSURL URLWithString:self];
    }
    else
    {
        URL = [NSURL fileURLWithPath:self];
    }
    /*
     Create an asset for inspection of a resource referenced by a given URL.
     Load the values for the asset keys "tracks", "playable".
     */
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:URL options:nil];
    
    if (asset.isPlayable)
    {
        NSArray* requestedKeys = @[@"playable"];
        /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
        [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:
         ^{
             LJXPerformBlockAsynOnMainThread(
                                            ^{
                                                /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                                                NSError *error = nil;
                                                AVKeyValueStatus keyStatus = [asset statusOfValueForKey:[requestedKeys lastObject] error:&error];
                                                if (playable) {
                                                    playable(keyStatus != AVKeyValueStatusFailed
                                                             || keyStatus != AVKeyValueStatusUnknown);
                                                }
                                            });
         }];
    }else{
        if (playable) {
            playable(NO);
        }
    }
}


- (NSString*)movieName
{
    NSArray* components = [self componentsSeparatedByString:@"|"];
    if ([components count] > 2) {
        return [components objectAtIndex:2];
    }
    return nil;
}



- (BOOL)isVideoFile:(NSString*)extentions
{
    return [self isFileWithExtention:extentions];
}

- (BOOL)isAudioFile:(NSString*)extentions
{
    return [self isFileWithExtention:extentions];
}

- (BOOL)isImageFile:(NSString*)extentions
{
    return [self isFileWithExtention:extentions];
}

- (BOOL)isSeedFile:(NSString*)extentions
{
    return [self isFileWithExtention:extentions];
}
@end
