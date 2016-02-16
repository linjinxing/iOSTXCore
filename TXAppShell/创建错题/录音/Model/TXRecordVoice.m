//
//  ViewController.m
//  Audio
//
//  Created by Jean-Pierre Simard on 12-05-30.
//  Copyright (c) 2012 Magnetic Bear Studios. All rights reserved.
//

#import "TXRecordVoice.h"
#import <AVFoundation/AVFoundation.h>
#import "CTHImageUtilities.h"

#define kdBOffset       40
#define kMeterRefresh   0.03

@interface TXRecordVoice ()<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
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
    
    if (err) { /* handle error */
        LJXNSError(err);
    }
    
    err = nil;
    
    
    [audioSession setActive:YES error:&err];
    
    if (err) {
        LJXNSError(err);
    }

    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&err];
    if (err) {
        LJXNSError(err);
    }
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    self.filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", @([[NSDate date] timeIntervalSince1970])]];
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
    player.delegate = self;
    NSLog(@"[%@] error:%@", NSStringFromSelector(_cmd), error);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.playbackDidFinish)
    {
        self.playbackDidFinish();
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    if (self.playbackDidFinish)
    {
        self.playbackDidFinish();
    }
}

- (void)stopRecording {
    self.duration = recorder.currentTime;
    NSLog(@"[%@] currentTime:%@, deviceCurrentTime:%@", NSStringFromSelector(_cmd), @(recorder.currentTime), @(recorder.deviceCurrentTime));
    [recorder stop];
    [levelTimer invalidate];
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
