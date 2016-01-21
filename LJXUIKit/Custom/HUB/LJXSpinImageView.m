//
//  LJXSpinImageView.m
//  iMoveHomeServer
//
//  Created by LoveYouForever on 11/28/14.
//  Copyright (c) 2014 i-Move. All rights reserved.
//

#import "LJXSpinImageView.h"

@interface LJXSpinImageView()

@property(assign, nonatomic) BOOL animating;
@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic) CGFloat angle;
@property (nonatomic,strong) UIActivityIndicatorView *view;

@end

@implementation LJXSpinImageView

- (instancetype)init
{
    self = [[[self class] alloc] initWithImage:[UIImage imageNamed:@"icon_loading-1"]];
    return self;
}


- (void)spinWithOptions: (UIViewAnimationOptions) options
{
    [UIView animateWithDuration: 0.2f
                          delay: 0.0f
                        options: options
                     animations: ^{
                         self.transform = CGAffineTransformRotate(self.transform, M_PI / 2);
                     }
                     completion: ^(BOOL finished) {
                         if (finished) {
                             if (self.animating) {
                                 // if flag still set, keep spinning with constant speed
                                 [self spinWithOptions: UIViewAnimationOptionCurveLinear];
                             } else if (options != UIViewAnimationOptionCurveEaseOut) {
                                 // one last spin, with deceleration
                                 [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
                             }
                         }
                     }];
}

- (void)startAnimating
{
    self.animating = YES;
    [self setupDisplayLink];
}

/**
 *  设置刷新定时器
 */
- (void)setupDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    if (hidden) {
        [self.displayLink invalidate];
    } else {
        [self setupDisplayLink];
    }
}

- (void)handleDisplayLink:(CADisplayLink *)displayLink {
    if (self.animating)
        self.angle += 0.13f;
    
    if (self.angle > 6.283)
        self.angle = 0.0f;
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(self.angle);
    self.transform = transform;
}

- (void)stopAnimating
{
        self.animating = NO;
        self.hidden = self.hidesWhenStopped;
        [self.displayLink invalidate];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
