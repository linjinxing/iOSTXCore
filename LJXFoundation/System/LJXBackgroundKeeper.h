//
//  BAViewController.h
//  BackgroundApp
//
//  Created by Sagi Iltus on 2/25/13.
//  Copyright (c) 2013 Vonage. All rights reserved.
//

//  需要后台KeepAlive的模块
typedef enum{
    
    LJXDowdingDemander = 0,
    LJXBigScreenDemander = 1,
    IMPrivateModeDemander = 2
    
}LJXBGAliveDemander;


#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface LJXBackgroundKeeper : NSObject  <AVAudioSessionDelegate>


//应用程序运行时执行
+ (void)addApplicationStausObserver;

//需要后台保持alive
+ (void)addDemanderWithIdentifer:(LJXBGAliveDemander)demander;

/*
 * 不再需要后台保持alive
 * 如何没有任何需求者，5秒内应用程序会终止
 */
+ (void)removeDemanderWithIdentifer:(LJXBGAliveDemander)demander;

@end
