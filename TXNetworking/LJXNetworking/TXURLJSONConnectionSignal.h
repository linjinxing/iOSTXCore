//
//  TXURLJSONConnectionSignal.h
//  LJXNetworking
//
//  Created by tongxing on 16/1/21.
//  Copyright © 2016年 Mobo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

RACSignal* TXURLJSONConnectionSignal(NSURLRequest* request, NSString* keyPath, Class cls);

