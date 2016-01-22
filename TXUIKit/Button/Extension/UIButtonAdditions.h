//
//  UIButton+category.h
//  BookReader
//
//  Created by mythlink on 10-11-9.
//  Copyright 2010 mythlink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIButton(create)

+(id)buttonWithType:(UIButtonType)type  tag:(NSInteger)tag;

+(id)buttonWithTitle:(NSString*)title ;
+(id)buttonWithTitle:(NSString*)title tag:(NSInteger)tag;

+(id)buttonWithImageName:(NSString*)imageName;
+(id)buttonWithImageName:(NSString*)imageName tag:(NSInteger)tag;

+(id)buttonWithImage:(UIImage*)image;
+(id)buttonWithImage:(UIImage*)image  tag:(NSInteger)tag;

+(id)buttonWithImage:(UIImage*)image nomalBgImage:(UIImage*)aNImage highlightedBgImage:(UIImage*)aHImage;
+(id)buttonWithNomalImage:(UIImage*)aNImage highlightedImage:(UIImage*)aHImage;
+(id)buttonWithTitle:(NSString*)title image:(UIImage*)image;
+(id)buttonWithTitle:(NSString*)title normaleImage:(UIImage*)normalImage 
               highlightedImage:(UIImage*)highlightedImage;

+(id)buttonWithNormalImage:(UIImage*)aNImage selectedImage:(UIImage*)aSImage;

+(id)button4NaviBarWithTitle:(NSString*)aTitle origin:(CGPoint)aPoint;

- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;

//上下居中，图片在上，文字在下
- (void)verticalCenterImageAndTitle:(CGFloat)spacing;
- (void)verticalCenterImageAndTitle; //默认6.0

//左右居中，文字在左，图片在右
- (void)horizontalCenterTitleAndImage:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImage; //默认6.0

//左右居中，图片在左，文字在右
- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;
- (void)horizontalCenterImageAndTitle; //默认6.0

//文字居中，图片在左边
- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageLeft; //默认6.0

//文字居中，图片在右边
- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageRight; //默认6.0

//-(id)initWithTitle:(NSString*)title ;
//-(id)initWithImageName:(NSString*)imageName;
//-(id)initWithImage:(UIImage*)image;
//-(id)initWithImage:(UIImage*)image nomalBgImage:(UIImage*)aNImage highlightedBgImage:(UIImage*)aHImage;
//-(id)initWithTitle:(NSString*)title tag:(NSInteger)tag;
//-(id)initWithNomalImage:(UIImage*)aNImage highlightedImage:(UIImage*)aHImage;
//-(id)initWithTitle:(NSString*)title image:(UIImage*)image;
//-(id)initWithTitle:(NSString*)title normaleImage:(UIImage*)normalImage
//           highlightedImage:(UIImage*)highlightedImage;
//
//-(id)initWithNormalImage:(UIImage*)aNImage selectedImage:(UIImage*)aSImage;


//- (void)setButtonAttributtionWithBundleItem:(NSString*)bundleItem;
@end
