//
//  CTHServerInterface.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/21.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "CTHServerInterface.h"
#import "CTHSubject.h"

@implementation CTHServerInterface
+ (void)load
{
    [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"getSubjects",@"userId":@"1"}, @"subjects", [CTHSubject class])
     subscribeNext:^(id x) {
         LJXLogObject(x);
    } error:^(NSError *error) {
        LJXNSError(error);
    }];
}

@end
