//
//  ViewController.m
//  Audio
//
//  Created by Jean-Pierre Simard on 12-05-30.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import "TXRecordVoice.h"
#import <AVFoundation/AVFoundation.h>

#define kdBOffset       40
#define kMeterRefresh   0.03

@interface TXRecordVoice ()<AVAudioRecorderDelegate>
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSTimer *levelTimer;
}
@end

@implementation TXRecordVoice
//@synthesize levelMeter;

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
	// Do any additional setup after loading the view, typically from a nib.
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if (err) { /* handle error */ }
    
    err = nil;
    
    [audioSession setActive:YES error:&err];
    
    if (err) { /* handle error */ }
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    self.filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", [[NSDate date] formatDateTime]]];
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    LJXFoundationLog("recording file path:%@", url);
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                              [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt:1], AVNumberOfChannelsKey, nil];
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url 
                                           settings:settings error:&err];
    
    if (!recorder) { /* handle error */ }
    
    [recorder setDelegate:self];
    return self;
}


- (void)startRecording{
    [recorder pause];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    [recorder record];
    [recorder updateMeters];
    levelTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.0] interval:kMeterRefresh target:self selector:@selector(levelTimerCallback:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:levelTimer forMode:NSDefaultRunLoopMode];
}

- (void)play {
	NSError *error;
    [player stop];
	player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:&error];
    [player play];
    NSLog(@"[%@] error:%@", NSStringFromSelector(_cmd), error);
}

- (void)stopRecording {
    [recorder stop];
    [levelTimer invalidate];
    self.duration = recorder.deviceCurrentTime;
    NSLog(@"[%@] currentTime:%@, deviceCurrentTime:%@", NSStringFromSelector(_cmd), @(recorder.currentTime), @(recorder.deviceCurrentTime));
}

- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    CGFloat value = ([recorder averagePowerForChannel:0]+kdBOffset)/kdBOffset;
//    NSLog(@"value:%f", value);
    if (self.updateMeter) {
        self.updateMeter(value);
    }
}
//
//- (NSURL*)recordURL{
//    return recorder.url;
////    NSData *myData = [NSData dataWithContentsOfURL:recorder.url];
//}

- (void)dealloc
{
    [levelTimer invalidate];
    levelTimer = nil;
}

@end
