//
//  LJXMultiStateButton.m
//  QvodUI
//
//  Created by steven on 3/17/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "LJXMultiStateButton.h"
#import "UIButtonAdditions.h"
#import "UIView+Layout.h"

@interface LJXMultiStateButton()
//@property(nonatomic, strong)NSArray* arrStateImages;
@end

@implementation LJXMultiStateButton
//@synthesize value;


- (void)dealloc
{
//    [self bk_removeAllBlockObservers];
}

#pragma mark - init


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        [self bk_addObserverForKeyPaths:@[@keypath(self.btnState), @keypath(self.images)] task:^(id obj, NSDictionary *keyPath) {
//            LJXUILog("keyPath:%@", keyPath);
//            
//        }];
    }
    return self;
}


#pragma mark - Update Image
-(void) updateImageWithState:(int)state {
    [self setImage:self.images[state] forState:UIControlStateNormal];
    self.size = [(UIImage*)self.images[state] size];
}

#pragma mark - Function Overriding
-(void) sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [super sendAction:action to:target forEvent:event];
//    self.btnState = (self.btnState < ([self.images count] - 1))? self.btnState + 1 : 0;
//    [self updateImageWithState:self.btnState];
}


#pragma mark -
- (void)setBtnState:(int)btnState
{
    if (_btnState != btnState) {
        _btnState = btnState;
        [self updateImageWithState:btnState];
    }
}

- (void)setBtnImages:(NSArray *)images
{
    if (_images != images) {
        _images = images;
        [self updateImageWithState:self.btnState];
    }
}

@end


