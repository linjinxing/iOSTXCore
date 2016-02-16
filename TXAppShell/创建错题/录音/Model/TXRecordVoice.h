//
//  ViewController.h
//  Audio
//
//  Created by Jean-Pierre Simard on 12-05-30.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TXRecordVoice : NSObject
@property(nonatomic, copy) void(^updateMeter)(CGFloat value);
@property(nonatomic, copy) LJXBlock playbackDidFinish;
@property(nonatomic, copy) NSString* filePath;
@property(nonatomic, assign) NSTimeInterval duration;
- (void)startRecording;
- (void)play;
- (void)stopRecording;
//- (NSURL*)recordURL;
//@property (weak, nonatomic) IBOutlet F3BarGauge *levelMeter;

@end
