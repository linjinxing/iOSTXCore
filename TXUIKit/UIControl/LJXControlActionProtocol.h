//
//  LJXControlAction.h
//  iMove
//
//  Created by linjinxing on 7/31/14.
//  Copyright (c) 2014 iMove. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJXUIBlocks.h"

@protocol LJXControlActionHandler <NSObject>
@property(nonatomic, copy)LJXControlAction actionHandler;
@end
