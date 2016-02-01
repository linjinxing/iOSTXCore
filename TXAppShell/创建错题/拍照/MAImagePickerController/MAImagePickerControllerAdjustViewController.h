//
//  MAImagePickerControllerAdjustViewController.h
//  instaoverlay
//
//  Created by Maximilian Mackh on 11/5/12.
//  Copyright (c) 2012 mackh ag. All rights reserved.
//

//Dedected Points

#import <UIKit/UIKit.h>

#import "MAConstants.h"
#import "MADrawRect.h"

@interface MAImagePickerControllerAdjustViewController : UIViewController
{
    BOOL isGray;
}
@property (copy, nonatomic) MAImagePickerDidFinish didFinish;
@property (copy, nonatomic) MAImagePickerDidCancel didCancel;
@property (strong, nonatomic) UIImage *sourceImage;
@end
