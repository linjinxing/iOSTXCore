//
//  BAViewController.m
//  BackgroundApp
//
//  Created by Sagi Iltus on 2/25/13.
//  Copyright (c) 2013 Vonage. All rights reserved.
//

#define kBackgroundRunningEnable @"BackgroundRunningEnable"//BackgroundDownloadingEnabled

#define BackgroundRunningEnableLocalBool @"BackgroundRunningEnableLocalBool"
#define backGroundRunningEnableLocalModifiedTime @"backGroundRunningEnableLocalModifiedTime"

#import "LJXBackgroundKeeper.h"
#import "LJXDebug.h"
//#import "JSONKit.h"
#import <SystemConfiguration/SystemConfiguration.h>



@interface LJXBackgroundContext:NSObject

@property AVPlayer * player;
@property NSTimer* demandersCheckTimer;
@property NSTimer* playMusicTimer;
@property NSMutableArray *bgTasksDemander;

@end

@implementation LJXBackgroundContext

- (id)init
{
    self = [super init];
    if (self) {
        self.bgTasksDemander = [[NSMutableArray alloc] init];
    }
    return self;
}

@end

static LJXBackgroundContext*  s_bc;

@implementation LJXBackgroundKeeper

+ (void)initialize
{
    if ([LJXBackgroundKeeper class] == self) {
        s_bc = [[LJXBackgroundContext alloc] init];
        [self initPlayer];
        [self ensureAudio];
    }
}

+ (void) addApplicationStausObserver
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterForeGround) name:UIApplicationWillEnterForegroundNotification object:nil];
}

+ (void)addDemanderWithIdentifer:(LJXBGAliveDemander)demander
{
    for (NSNumber *exist in s_bc.bgTasksDemander) {
        if ([exist intValue] == demander) {
            return;
        }
    }
    [s_bc.bgTasksDemander addObject:[NSNumber numberWithInt:demander]];
}

+ (void)removeDemanderWithIdentifer:(LJXBGAliveDemander)demander
{
    long index = -1;
    for (NSString *exist in s_bc.bgTasksDemander) {
        if ([exist intValue] == demander) {
            index = [s_bc.bgTasksDemander indexOfObject:exist];
        }
    }
    if (index > -1) {
        [s_bc.bgTasksDemander removeObjectAtIndex:index];
    }
}



+ (void)resignActive
{
    [s_bc.player play];
}

+ (void)enterBackGround
{
    s_bc.demandersCheckTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    
    if ([self backGroundRunningEnable]) {
            s_bc.playMusicTimer = [NSTimer scheduledTimerWithTimeInterval:25 target:self selector:@selector(reStartMusic) userInfo:nil repeats:YES];
    }

}

+ (void)enterForeGround
{
    //停止记录日志
    LJXFoundationLog("Coming back to Foreground");
    [s_bc.demandersCheckTimer invalidate];
    s_bc.demandersCheckTimer = nil;
    
    [self destroyPlayer];
    [self initPlayer];

    [s_bc.playMusicTimer invalidate];
    s_bc.playMusicTimer = nil;
}

+ (void)timerTicked:(NSTimer*)timer
{
    LJXFoundationLog("Background is alive!");

    if ([s_bc.bgTasksDemander count] == 0) {
        LJXFoundationLog("Need not to alive");
        [self destroyPlayer];
        
        [s_bc.playMusicTimer invalidate];
        s_bc.playMusicTimer = nil;
    }
    else{
        LJXFoundationLog("Demanders are:");
        for (NSNumber *damander in s_bc.bgTasksDemander) {
            LJXFoundationLog("%d",[damander intValue]);
        }
    }
}

#pragma mark Background audio
+ (void)initPlayer
{
    NSString* trackName = @"silence";
    
    LJXFoundationLog("init audio player with track: %@", trackName);
    NSString* path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"LJXFoundation.bundle"];
    NSBundle* bundle = [NSBundle bundleWithPath:path];
    NSURL * file = [bundle URLForResource:trackName withExtension:@"mp3"];
    
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:file options:nil];
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithAsset:asset];
    s_bc.player = [[AVPlayer alloc]initWithPlayerItem:item];
    __block id finishObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                                                  object:s_bc.player.currentItem
                                                                                   queue:[NSOperationQueue mainQueue]
                                                                              usingBlock:^(NSNotification *note) {
                                                                                  
                                                                                  LJXFoundationLog("Finished Playing Audio");
                                                                                  [[NSNotificationCenter defaultCenter] removeObserver:finishObserver];
                                                                                  
                                                                                  s_bc.player = nil;
                                                                              }];
    
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        LJXFoundationLog("Ready Playing Audio");
    }];
}

+ (void)playMusic
{
    [s_bc.player play];
}

+ (void) reStartMusic
{
    [self rewindMusic];
    [self playMusic];
}
+ (void)rewindMusic
{
    [s_bc.player seekToTime:kCMTimeZero];
}

+(void)destroyPlayer
{
    s_bc.player=nil;
}


#pragma mark

+ (BOOL) ensureAudio
{
    // Registers this class as the delegate of the audio session (to get background sound)
    [[AVAudioSession sharedInstance] setDelegate: [self class]];
    
    // Set category
    if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]) {
        LJXFoundationLog("Audio session category could not be set");
        return NO;
    }
    
    // Activate session
    if (![[AVAudioSession sharedInstance] setActive: YES error: nil]) {
        LJXFoundationLog("Audio session could not be activated");
        return NO;
    }
    
    // Allow the audio to mix with other apps (necessary for background sound)
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doChangeDefaultRoute), &doChangeDefaultRoute);
    
    return YES;
}

+ (void) beginInterruption
{
    
}

+ (void) endInterruption
{
    // Sometimes the audio session will be reset/stopped by an interruption
    [self ensureAudio];
}

+ (void) inputIsAvailableChanged:(BOOL)isInputAvailable
{
    
}

#pragma mark
+ (BOOL) backGroundRunningEnable
{
    return NO;
//    NSURL *url = [NSURL URLWithString:@"http://ios.dl.kuaibo.com/ios/LJXCfg.json"];
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//
//    //1、判断服务器文件是否有更新
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:url];
//    [request setHTTPMethod:@"HEAD"];
//    [request setTimeoutInterval:5];
//    
//    NSHTTPURLResponse *response;
//    NSError *error;
//    [NSURLConnection sendSynchronousRequest:request
//                          returningResponse:&response
//                                      error:&error];
//    
//    //2、获取失败返回本地存储的值
//    if (error) {
//        BOOL isEnable = [ud boolForKey:BackgroundRunningEnableLocalBool];
//        LJXFoundationLog("后台下载（网络不通，本地）isEnable:%@",isEnable?@"YES":@"NO");
//        return isEnable;
//    }
//    else{
//        LJXFoundationLog("网络联通");
//    }
//    
//
//    NSDictionary *allHeadFields = [response allHeaderFields];
//    NSString *serverModifiedDate = [allHeadFields objectForKey:@"Last-Modified"];
//    NSString *localModifiedDate = [ud objectForKey:backGroundRunningEnableLocalModifiedTime];
//    
//    //2、若更新重新获取，否则用本地存储的标志
//    BOOL isNeedUpdate = ![serverModifiedDate isEqualToString:localModifiedDate];
//    if (isNeedUpdate) {
//        NSString *jsonConfig = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
//        
//        LJXFoundationLog("后台下载（服务器）：jsonConfig%@",jsonConfig);
//        NSDictionary *dicConfig;
//        @try {
//            dicConfig = [NSDictionary dictionaryWithJSON:jsonConfig];
//        }
//        @catch (NSException *exception) {
//            BOOL isEnable = [ud boolForKey:BackgroundRunningEnableLocalBool];
//            LJXFoundationLog("后台下载（服务器）：获取失败，返回本地isEnable:%@",isEnable?@"YES":@"NO");
//            return isEnable;
//        }
//        LJXFoundationLog("后台下载（服务器）：dicConfig%@",dicConfig);
//        BOOL isEnable = [[dicConfig objectForKey:kBackgroundRunningEnable] boolValue];
//        LJXFoundationLog("后台下载（服务器）：isEnable:%@",isEnable?@"YES":@"NO");
//        
//        [ud setObject:serverModifiedDate forKey:backGroundRunningEnableLocalModifiedTime];
//        [ud setBool:isEnable forKey:BackgroundRunningEnableLocalBool];
//        
//        return isEnable;
//
//    }
//    else{
//        
//        BOOL isEnable = [ud boolForKey:BackgroundRunningEnableLocalBool];
//        LJXFoundationLog("后台下载（本地）isEnable:%@",isEnable?@"YES":@"NO");
//        return isEnable;
//    }
    
}



@end
