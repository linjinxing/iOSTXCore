//
//  UIDeviceAdditions.m
//  QvodBrowser
//
//  Created by steven lin on 3/8/12.
//  Copyright (c) 2012 qvod. All rights reserved.
//

#import "UIDeviceAdditions.h"


@implementation UIDevice(Additions)
+ (void)setInterfaceOrientation:(UIInterfaceOrientation) o
{
    UIDevice* dev = [UIDevice currentDevice];
//    if (o != (UIInterfaceOrientation)[dev orientation])
    {
        SEL sel = @selector( setOrientation:);
        if ([dev respondsToSelector:sel]) {
            NSMethodSignature *sig = [dev methodSignatureForSelector:sel];
            if (sig && [dev respondsToSelector:sel])
            {
                NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
                [invo setTarget:dev];
                [invo setSelector:sel];
                [invo setArgument:(void *)(&o) atIndex:2];
                [invo invoke];
            }
        }
    }
//    if (o != [[UIApplication sharedApplication] statusBarOrientation])
    {
        [[UIApplication sharedApplication] setStatusBarOrientation:o animated:NO];
    }
}

@end
