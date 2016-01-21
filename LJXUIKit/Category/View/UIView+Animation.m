//
//  UIView+Animation.m
//  CoolUIViewAnimations
//
//  Created by Peter de Tagyos on 12/10/11.
//  Copyright (c) 2011 PT Software Solutions. All rights reserved.
//

#import "UIView+Animation.h"


// Very helpful function

float radiansForDegrees(int degrees) {
    return degrees * M_PI / 180;
}


@implementation UIView (Animation)

#pragma mark - Moves

- (void)moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option {
    [self moveTo:destination duration:secs option:option delegate:nil callback:nil];
}

- (void)moveTo:(CGPoint)destination duration:(float)secs option:(UIViewAnimationOptions)option delegate:(id)delegate callback:(SEL)method {
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         self.frame = CGRectMake(destination.x,destination.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (delegate != nil) {
                             [delegate performSelector:method];
                         }
                     }];
}

- (void)raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack {
    [self raceTo:destination withSnapBack:withSnapBack delegate:nil callback:nil];
}

- (void)raceTo:(CGPoint)destination withSnapBack:(BOOL)withSnapBack delegate:(id)delegate callback:(SEL)method {
    CGPoint stopPoint = destination;
    if (withSnapBack) {
        // Determine our stop point, from which we will "snap back" to the final destination
        int diffx = destination.x - self.frame.origin.x;
        int diffy = destination.y - self.frame.origin.y;
        if (diffx < 0) {
            // Destination is to the left of current position
            stopPoint.x -= 10.0;
        } else if (diffx > 0) {
            stopPoint.x += 10.0;
        }
        if (diffy < 0) {
            // Destination is to the left of current position
            stopPoint.y -= 10.0;
        } else if (diffy > 0) {
            stopPoint.y += 10.0;
        }
    }
    
    // Do the animation
    [UIView animateWithDuration:0.3 
                          delay:0.0 
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         self.frame = CGRectMake(stopPoint.x, stopPoint.y, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (withSnapBack) {
                             [UIView animateWithDuration:0.1 
                                                   delay:0.0 
                                                 options:UIViewAnimationCurveLinear
                                              animations:^{
                                                  self.frame = CGRectMake(destination.x, destination.y, self.frame.size.width, self.frame.size.height);
                                              }
                                              completion:^(BOOL finished) {
                                                  [delegate performSelector:method];
                                              }];
                         } else {
                             [delegate performSelector:method];
                         }
                     }];        
}


#pragma mark - Transforms

- (void)rotate:(int)degrees secs:(float)secs delegate:(id)delegate callback:(SEL)method {
    [UIView animateWithDuration:secs 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, radiansForDegrees(degrees));
                     }
                     completion:^(BOOL finished) { 
                         if (delegate != nil) {
                             [delegate performSelector:method];
                         }
                     }];
}

- (void)scale:(float)secs x:(float)scaleX y:(float)scaleY delegate:(id)delegate callback:(SEL)method {
    [UIView animateWithDuration:secs 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformScale(self.transform, scaleX, scaleY);
                     }
                     completion:^(BOOL finished) { 
                         if (delegate != nil) {
                             [delegate performSelector:method];
                         }
                     }];
}

- (void)spinClockwise:(float)secs {
    [UIView animateWithDuration:secs/4 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, radiansForDegrees(90));
                     }
                     completion:^(BOOL finished) { 
                         [self spinClockwise:secs];
                     }];
}

- (void)spinCounterClockwise:(float)secs {
    [UIView animateWithDuration:secs/4 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.transform = CGAffineTransformRotate(self.transform, radiansForDegrees(270));
                     }
                     completion:^(BOOL finished) { 
                         [self spinCounterClockwise:secs];
                     }];
}


#pragma mark - Transitions

- (void)curlDown:(float)secs {
    [UIView transitionWithView:self duration:secs
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^ { [self setAlpha:1.0]; }
                    completion:nil];
}

- (void)curlUpAndAway:(float)secs {
    [UIView transitionWithView:self duration:secs
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^ { [self setAlpha:0]; }
                    completion:nil];
}

- (void)drainAway:(float)secs {
	NSTimer *timer;
    self.tag = 20;
	timer = [NSTimer scheduledTimerWithTimeInterval:secs/50 target:self selector:@selector(drainTimer:) userInfo:nil repeats:YES];
}

- (void)drainTimer:(NSTimer*)timer {
	CGAffineTransform trans = CGAffineTransformRotate(CGAffineTransformScale(self.transform, 0.9, 0.9),0.314);
	self.transform = trans;
	self.alpha = self.alpha * 0.98;
	self.tag = self.tag - 1;
	if (self.tag <= 0) {
		[timer invalidate];
		[self removeFromSuperview];
	}
}

#pragma mark - Effects

- (void)changeAlpha:(float)newAlpha secs:(float)secs {
    [UIView animateWithDuration:secs 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.alpha = newAlpha;
                     }
                     completion:nil];
}

- (void)pulse:(float)secs continuously:(BOOL)continuously {
    [UIView animateWithDuration:secs/2 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Fade out, but not completely
                         self.alpha = 0.3;
                     }
                     completion:^(BOOL finished) { 
                         [UIView animateWithDuration:secs/2 
                                               delay:0.0 
                                             options:UIViewAnimationOptionCurveLinear
                                          animations:^{
                                              // Fade in
                                              self.alpha = 1.0;
                                          }
                                          completion:^(BOOL finished) { 
                                              if (continuously) {
                                                  [self pulse:secs continuously:continuously];
                                              }
                                          }];
                     }];
}



-(void)addSubviewFlipAnimation:(UIView *)addedView right:(BOOL)bRight
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition: bRight ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft
                           forView:self
                             cache:YES];
    [self addSubview:addedView];
    [UIView commitAnimations];
    [self bringSubviewToFront:addedView];
}


-(void)addSubviewFlipAnimation:(UIView *)addedView hiddenView:(UIView*)hiddenView up:(BOOL)bUp
{
    if (nil == addedView.superview) {
        [self addSubview:addedView];
    }
    [UIView beginAnimations:@"ViewExcangeAnimation" context:nil];
    [UIView setAnimationDuration:0.75f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:bUp ? UIViewAnimationTransitionCurlUp : UIViewAnimationTransitionCurlDown
                           forView:self cache:YES];
    NSInteger hidenViewIndex = [self.subviews indexOfObject:hiddenView];
    NSInteger showViewIndex = [self.subviews indexOfObject:addedView];
    [self exchangeSubviewAtIndex:hidenViewIndex withSubviewAtIndex:showViewIndex];
    [UIView commitAnimations];
    addedView.hidden = NO;
    hiddenView.hidden = YES;
    [self bringSubviewToFront:addedView];
}

- (void)removeSubviewFlipAnimation:(UIView *)removedView right:(BOOL)bRight
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition: bRight ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft
                           forView:self
                             cache:YES];
    [removedView removeFromSuperview];
    [UIView commitAnimations];
}

-(void)animationToFrame:(CGRect)frame
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self setFrame:frame];
    [UIView commitAnimations];
}
-(void)animationToFrame:(CGRect)frame duration:(NSTimeInterval)duration delegate:(id)delegate
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:delegate];
    [self setFrame:frame];
    [UIView commitAnimations];
}

- (void)fadeAlphaTo:(CGFloat)targetAlpha andPerformSelector:(SEL)selector withObject:(id)object {
	// Don't fade and perform selector if alpha is already target alpha
	if (self.alpha == targetAlpha) {
		return;
	}
	
	// Perform fade
	[UIView beginAnimations:@"fadealpha" context:nil];
	self.alpha = targetAlpha;
	[UIView commitAnimations];
	
	// Perform selector after animation
	if (selector) {
		[self performSelector:selector withObject:object afterDelay:0.21];
	}
}

- (void)fadeIn {
	[self fadeAlphaTo:1.0f andPerformSelector:NULL withObject:nil];
}


- (void)fadeOut {
	[self fadeAlphaTo:0.0f andPerformSelector:NULL withObject:nil];
}


@end
