//
//  TXURLJSONConnectionSignal.m
//  LJXNetworking
//
//  Created by tongxing on 16/1/21.
//  Copyright © 2016年 Mobo. All rights reserved.
//

#import "TXURLJSONConnectionSignal.h"
#import "LJXURLJSONConnection.h"

RACSignal* TXURLJSONConnectionSignal(NSURLRequest* request, NSString* keyPath, Class cls)
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        LJXURLJSONConnection(request,
                             keyPath,
                             cls,
                             ^(id result) {
            [subscriber sendNext:result];
            [subscriber sendCompleted];
        }, ^(NSError *error, id respondseObject) {
            [subscriber sendError:error];
        });
        return nil;
    }];
}