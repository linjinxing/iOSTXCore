//
//  MAImagePickerFinalViewController.m
//  instaoverlay
//
//  Created by Maximilian Mackh on 11/10/12.
//  Copyright (c) 2012 mackh ag. All rights reserved.
//

#import "MAImagePickerFinalViewController.h"

#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "MAOpenCV.h"
#import "MADrawRect.h"
#import "UIImageView+ContentFrame.h"
#import "MDScratchImageView.h"

static NSUInteger strokes[] = {3, 6, 10, 15};

@interface MAImagePickerFinalViewController ()

@property(nonatomic, assign) BOOL firstCrop;
@property(nonatomic, assign) NSUInteger lastActionTag;
//@property(nonatomic, assign) NSUInteger strokeRaidus;
//@property (strong, nonatomic) UIImage *adjustedImage;
@property(nonatomic, weak) IBOutlet MADrawRect* viewCrop;
@property (weak, nonatomic) IBOutlet MDScratchImageView *finalImageView;
@property (weak, nonatomic) IBOutlet UIView* viewScratchStroke;
@end

@implementation MAImagePickerFinalViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lastActionTag = EditActionTagCrop;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.finalImageView setImage:self.sourceImage];
    self.finalImageView.radius = strokes[0];
//    @weakify(self)
//     [RACObserve(self.finalImageView, bounds) subscribeNext:^(id x) {
//        @strongify(self)
//
//     }];
//    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.viewCrop.frame = self.finalImageView.bounds;
    [self.viewCrop setup];
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)comfirmFinishedImage
{
    [self storeImageToCache];
}


- (void)adjustPreviewImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UIImage* adjustedImage = self.finalImageView.image;
  
        cv::Mat original;
            if (_imageFrameEdited)
            {
                original = [MAOpenCV cvMatGrayFromAdjustedUIImage:adjustedImage];
            }
            else
            {
                original = [MAOpenCV cvMatGrayFromUIImage:adjustedImage];
            }
            
            cv::GaussianBlur(original, original, cvSize(11,11), 0);
            cv::adaptiveThreshold(original, original, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 5, 2);
            adjustedImage = [MAOpenCV UIImageFromCVMat:original];
            
            original.release();
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           if (adjustedImage != self.finalImageView.image) {
                               [self.finalImageView setImage:adjustedImage];
                           }
                       });
    });
}

- (void) updateImageView
{
    [self.finalImageView setNeedsDisplay];
//    [self.finalImageView setImage:self.adjustedImage];
}

- (void) updateImageViewAnimated
{
//    self.finalImageView.image = self.adjustedImage;
}


- (void)storeImageToCache
{
    NSString *tmpPath = [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"maimagepickercontollerfinalimage.jpg"];
    NSData* imageData = UIImageJPEGRepresentation(self.finalImageView.image, 0.8);
    [imageData writeToFile:tmpPath atomically:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MAIPCSuccessInternal" object:tmpPath];
}


- (void)rotateImage
{
    switch (self.self.finalImageView.image.imageOrientation)
    {
        case UIImageOrientationRight:
            self.finalImageView.image = [[UIImage alloc] initWithCGImage: self.finalImageView.image.CGImage
                                                        scale: 1.0
                                                  orientation: UIImageOrientationDown];
            break;
        case UIImageOrientationDown:
            self.finalImageView.image = [[UIImage alloc] initWithCGImage: self.finalImageView.image.CGImage
                                                        scale: 1.0
                                                  orientation: UIImageOrientationLeft];
            break;
        case UIImageOrientationLeft:
            self.finalImageView.image = [[UIImage alloc] initWithCGImage: self.finalImageView.image.CGImage
                                                        scale: 1.0
                                                  orientation: UIImageOrientationUp];
            break;
        case UIImageOrientationUp:
            self.finalImageView.image = [[UIImage alloc] initWithCGImage: self.finalImageView.image.CGImage
                                                        scale: 1.0
                                                  orientation: UIImageOrientationRight];
            break;
        default:
            break;
    }
    
    
    [self updateImageViewAnimated];
    
}

- (void)confirmedImage
{
    if ([self.viewCrop frameEdited] || !self.firstCrop)
    {
        //cv::GaussianBlur(original, original, cvSize(11,11), 0);
        //cv::adaptiveThreshold(original, original, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 5, 2);
        
        CGFloat scaleFactor =  [self.finalImageView contentScale];
        CGPoint ptBottomLeft = [self.viewCrop coordinatesForPoint:1 withScaleFactor:scaleFactor];
        CGPoint ptBottomRight = [self.viewCrop coordinatesForPoint:2 withScaleFactor:scaleFactor];
        CGPoint ptTopRight = [self.viewCrop coordinatesForPoint:3 withScaleFactor:scaleFactor];
        CGPoint ptTopLeft = [self.viewCrop coordinatesForPoint:4 withScaleFactor:scaleFactor];
        
        CGFloat w1 = sqrt( pow(ptBottomRight.x - ptBottomLeft.x , 2) + pow(ptBottomRight.x - ptBottomLeft.x, 2));
        CGFloat w2 = sqrt( pow(ptTopRight.x - ptTopLeft.x , 2) + pow(ptTopRight.x - ptTopLeft.x, 2));
        
        CGFloat h1 = sqrt( pow(ptTopRight.y - ptBottomRight.y , 2) + pow(ptTopRight.y - ptBottomRight.y, 2));
        CGFloat h2 = sqrt( pow(ptTopLeft.y - ptBottomLeft.y , 2) + pow(ptTopLeft.y - ptBottomLeft.y, 2));
        
        CGFloat maxWidth = (w1 < w2) ? w1 : w2;
        CGFloat maxHeight = (h1 < h2) ? h1 : h2;
        
        cv::Point2f src[4], dst[4];
        src[0].x = ptTopLeft.x;
        src[0].y = ptTopLeft.y;
        src[1].x = ptTopRight.x;
        src[1].y = ptTopRight.y;
        src[2].x = ptBottomRight.x;
        src[2].y = ptBottomRight.y;
        src[3].x = ptBottomLeft.x;
        src[3].y = ptBottomLeft.y;
        
        dst[0].x = 0;
        dst[0].y = 0;
        dst[1].x = maxWidth - 1;
        dst[1].y = 0;
        dst[2].x = maxWidth - 1;
        dst[2].y = maxHeight - 1;
        dst[3].x = 0;
        dst[3].y = maxHeight - 1;
        
        cv::Mat undistorted = cv::Mat( cvSize(maxWidth,maxHeight), CV_8UC1);
        cv::Mat original = [MAOpenCV cvMatFromUIImage:self.finalImageView.image];
        cv::warpPerspective(original, undistorted, cv::getPerspectiveTransform(src, dst), cvSize(maxWidth, maxHeight));
        original.release();
        UIImage* image = [MAOpenCV UIImageFromCVMat:undistorted];;
        undistorted.release();
        LJXPerformBlockAsynOnMainThread(^{
            self.finalImageView.image = image;
            if (!self.firstCrop) {
                self.firstCrop = YES;
//                [self adjustPreviewImage];
            }
        });
        LJXFoundationLog("no change");
    }
}

enum EditAction{
    EditActionTagCrop,
    EditActionTagScatch,
    EditActionTagRecover,
    EditActionTagUseOriginalImage,
    EditActionTagReturn,
    EditActionTagRotateLeft,
    EditActionTagRotateRight,
    EditActionTagSave,
};

- (IBAction)stokeAction:(id)sender
{
    self.finalImageView.radius = strokes[[sender tag]];
}

- (IBAction)editAction:(id)sender
{
    if (EditActionTagCrop == [sender tag]) {
        self.viewCrop.hidden = NO;
        [self.viewCrop resetFrame];
    }else{
        self.viewCrop.hidden = YES;
        if (EditActionTagCrop == self.lastActionTag) {
            [self confirmedImage];
        }
    }
    self.viewScratchStroke.hidden = EditActionTagScatch != [sender tag];
    self.finalImageView.userInteractionEnabled = EditActionTagScatch == [sender tag];
    switch ([sender tag]) {
//        case EditActionTagScatch:
//        {
////            [self adjustPreviewImage:4];
//            break;
//        }
        case EditActionTagRecover:
        {
            [self.finalImageView reset];
            break;
        }
        case EditActionTagUseOriginalImage:
        {
            self.finalImageView.image = self.sourceImage;
            break;
        }
        case EditActionTagReturn:
        {
            [self popCurrentViewController];
            break;
        }
        case EditActionTagRotateLeft:
        {
            [self rotateImage];
            break;
        }
        case EditActionTagRotateRight:
        {
            [self rotateImage];
            break;
        }
        case EditActionTagSave:
        {
            
            break;
        }
        default:
            break;
    }
    self.lastActionTag = [sender tag];
}

@end
