//
//  LJXButton.m
//  QvodUI
//
//  Created by steven on 2/1/13.
//  Copyright (c) 2013 steven. All rights reserved.
//

#import "LJXButton.h"
#import "UIView+Layout.h"

@interface LJXButton()

@end


@implementation LJXButton
@synthesize actionHandler;
//- (void)dealloc
//{
//    [self bk_removeAllBlockObservers];
//}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.verticalSpace = 3.0f;
//        DeclareWeakSelf;
		[self addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void)action:(id)sender
{
	if (self.actionHandler) {
		self.actionHandler(sender, nil, UIControlEventTouchUpInside);
	}
}

//- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
//{
//    [super addTarget:self action:@selector(action:) forControlEvents:controlEvents];
//}

//- (void)addActionBlock:(LJXButtonActionBlock)block forControlEvents:(UIControlEvents)events
//{
//    
//}

//- (void)action:(UIButton*)button
//{
//    if (self.touchUpAction) self.touchUpAction(self);
//}

- (CGSize)sizeThatFits:(CGSize)aSize
{
    CGSize size = CGSizeZero;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSString* title = self.currentTitle;
    if (nil == title) {
        title = [self titleForState:self.state];
    }
    
    UIImage* image = self.currentImage;
    if (nil == image) {
        image = [self imageForState:self.state];
    }
    if (image) {
        imageSize = self.currentImage.size;
    }

    if ([title length])
    {
        if ([title respondsToSelector:@selector(sizeWithAttributes:)]) {
           titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
        }else{
           titleSize = [title sizeWithFont:self.titleLabel.font];
        }
    }
    LJXFoundationLog("asize:%@, size:%@, title:%@, image:%@", NSStringFromCGSize(aSize), NSStringFromCGSize(size), title, image);
    
    CGFloat maxWidth = MAX(imageSize.width, titleSize.width);
    CGFloat maxHeight = MAX(imageSize.height, titleSize.height);
    
    switch (self.layout) {
        case LJXBL_ImageTop:
        {
            size = CGSizeMake(self.verticalSpace * 2 + maxWidth, self.verticalSpace*3 + titleSize.height + imageSize.height);
            break;
        }
        case LJXBL_ImageLeft:
        case LJXBL_ImageRight:
        {
            size = CGSizeMake(self.verticalSpace * 3 + imageSize.width + titleSize.width, self.verticalSpace*2 + maxHeight);
            break;
        }
        default:
            size = [super sizeThatFits:aSize];
            break;
    }
#ifdef DEBUG
    if (LJXFloatIsEqual(size.width, 38.0f)) {
        LJXFoundationLog("size:%@", NSStringFromCGSize(size));
    }
#endif
    LJXFoundationLog("size:%@", NSStringFromCGSize(size));
//    size.height += (self.contentEdgeInsets.top + self.contentEdgeInsets.bottom);
//    size.width  += (self.contentEdgeInsets.left + self.contentEdgeInsets.right);
//    if (image) {
//        size.height += (self.imageEdgeInsets.top + self.imageEdgeInsets.bottom);
//        size.width  += (self.imageEdgeInsets.left + self.imageEdgeInsets.right);
//    }else if (title) {
//        size.height += (self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);
//        size.width  += (self.titleEdgeInsets.left + self.titleEdgeInsets.right);
//    }
    return size;   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    CGSize size = [self.currentTitle sizeWithFont:self.titleLabel.font];
    CGSize size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    if (size.width > self.titleLabel.width) {
        self.titleLabel.size = size;
    }
    switch (self.layout) {
        case LJXBL_ImageTop:
        {
            [self layoutSubviews:@[self.imageView, self.titleLabel]  withOrientaion:UIInterfaceOrientationPortrait];
            break;
        }
        case LJXBL_ImageLeft:
        {
            self.adjustsImageWhenHighlighted = NO;  
            [self layoutSubviews:@[self.imageView, self.titleLabel]  withOrientaion:UIInterfaceOrientationLandscapeLeft];
            break;
        }
        case LJXBL_ImageRight:
        {
            [self layoutSubviews:@[self.imageView, self.titleLabel]  withOrientaion:UIInterfaceOrientationLandscapeRight];
            break;
        }
        default:
            self.titleLabel.frame = self.bounds;
            self.imageView.frame = self.bounds;
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
