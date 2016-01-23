//
//  TXURLJSONConnectionSignal.m
//  LJXNetworking
//
//  Created by tongxing on 16/1/21.
//  Copyright © 2016年 Mobo. All rights reserved.
//

#import "TXURLJSONConnectionSignal.h"
#import "LJXURLJSONConnection.h"
#import "TXFoundation.h"

RACSignal* TXURLJSONConnectionSignal(NSURLRequest* request, NSString* keyPath, Class cls)
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        LJXURLJSONConnection(request,
                             keyPath,
                             cls,
                             ^(id result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        },
                             ^(NSError *error, id respondseObject) {
            [subscriber sendError:error];
        });
        return nil;
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    /* 在主线程中执行，目前无法正常工作 */
}