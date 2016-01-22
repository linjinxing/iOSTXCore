//
//  LJXSpinImageView.h
//  iMoveHomeServer
//
//  Created by LoveYouForever on 11/28/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJXSpinImageView : UIImageView

- (void)startAnimating;
- (void)stopAnimating;
@property(nonatomic) BOOL hidesWhenStopped;

@end
