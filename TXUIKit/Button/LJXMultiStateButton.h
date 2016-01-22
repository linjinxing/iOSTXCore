//
//  LJXMultiStateButton.h
//  QvodUI
//
//  Created by steven on 3/17/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJXButton.h"

@interface LJXMultiStateButton : LJXButton
@property (nonatomic, assign, setter = setBtnState:) int btnState;
@property (nonatomic, strong, setter = setBtnImages:) NSArray* images;
@end
