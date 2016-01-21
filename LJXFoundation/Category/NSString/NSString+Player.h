//
//  NSString+Player.h
//  iMove
//
//  Created by linjinxing on 14-8-12.
//  Copyright (c) 2014年 iMove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJXTypes.h"

@interface NSString (Player)
- (NSString*)movieName;
-(BOOL)isSystemSupportedVideoFormmat;
-(BOOL)isExtendSystemSupportedVideoFormmat;
- (void)isSystemSupportedMovieFormmat:(LJXBoolBlock)playable;
- (BOOL)isVideoFile:(NSString*)extentions;
- (BOOL)isAudioFile:(NSString*)extentions;
- (BOOL)isImageFile:(NSString*)extentions;
- (BOOL)isSeedFile:(NSString*)extentions;
@end
