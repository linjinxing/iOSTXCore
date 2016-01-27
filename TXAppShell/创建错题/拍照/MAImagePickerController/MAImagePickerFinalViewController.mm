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

@interface MAImagePickerFinalViewController ()

@property(nonatomic, assign) BOOL firstCrop;
@property (strong, nonatomic) UIImage *adjustedImage;
@property(nonatomic, weak) IBOutlet MADrawRect* viewCrop;
@property (weak, nonatomic) IBOutlet UIImageView *finalImageView;
@property (weak, nonatomic) IBOutlet UIView* viewScratchStroke;
@end

@implementation MAImagePickerFinalViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.finalImageView.image = self.adjustedImage = self.sourceImage;
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)comfirmFinishedImage
{
    [self storeImageToCache];
}

- (void)adjustPreviewImage:(NSUInteger)filter
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        _adjustedImage = _sourceImage;
        
        if (filter == 1)
        {
            
        }
        
        if (filter != 1)
        {
            
            cv::Mat original;
            
            if (filter == 2)
            {
                if (_imageFrameEdited)
                {
                    original = [MAOpenCV cvMatGrayFromAdjustedUIImage:_sourceImage];
                }
                else
                {
                    original = [MAOpenCV cvMatGrayFromUIImage:_sourceImage];
                }
                
                cv::GaussianBlur(original, original, cvSize(11,11), 0);
                cv::adaptiveThreshold(original, original, 255, cv::ADAPTIVE_THRESH_MEAN_C, cv::THRESH_BINARY, 5, 2);
                _adjustedImage = [MAOpenCV UIImageFromCVMat:original];
                
                original.release();
            }
            
            if (filter == 3)
            {
                if (_imageFrameEdited)
                {
                    original = [MAOpenCV cvMatGrayFromAdjustedUIImage:_sourceImage];
                }
                else
                {
                    original = [MAOpenCV cvMatGrayFromUIImage:_sourceImage];
                }
                
                cv::Mat new_image = cv::Mat::zeros( original.size(), original.type() );
                
                original.convertTo(new_image, -1, 1.4, -50);
                original.release();
                
                _adjustedImage = [MAOpenCV UIImageFromCVMat:new_image];
                new_image.release();
            }
            
            if (filter == 4)
            {
                if (_imageFrameEdited)
                {
                    original = [MAOpenCV cvMatFromAdjustedUIImage:_sourceImage];
                }
                else
                {
                    original = [MAOpenCV cvMatFromUIImage:_sourceImage];
                }
                
                cv::Mat new_image = cv::Mat::zeros( original.size(), original.type() );
                
                original.convertTo(new_image, -1, 1.9, -80);
                
                original.release();
                
                _adjustedImage = [MAOpenCV UIImageFromCVMat:new_image];
                new_image.release();
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self updateImageView];
                       });
    });
}

- (void) updateImageView
{
    [_finalImageView setNeedsDisplay];
    [_finalImageView setImage:_adjustedImage];
}

- (void) updateImageViewAnimated
{
    _finalImageView.image = _adjustedImage;
}


- (void)storeImageToCache
{
    NSString *tmpPath = [NSString stringWithFormat:@"%@/%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], @"maimagepickercontollerfinalimage.jpg"];
    NSData* imageData = UIImageJPEGRepresentation(_adjustedImage, 0.8);
    [imageData writeToFile:tmpPath atomically:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MAIPCSuccessInternal" object:tmpPath];
}


- (void)rotateImage
{
    switch (_adjustedImage.imageOrientation)
    {
        case UIImageOrientationRight:
            _adjustedImage = [[UIImage alloc] initWithCGImage: _adjustedImage.CGImage
                                                        scale: 1.0
                                                  orientation: UIImageOrientationDown];
            break;
        case UIImageOrientationDown:
            _adjustedImage = [[UIImage alloc] initWithCGImage: _adjustedImage.CGImage
                                                        scale: 1.0
                                                  orientation: UIImageOrientationLeft];
            break;
        case UIImageOrientationLeft:
            _adjustedImage = [[UIImage alloc] initWithCGImage: _adjustedImage.CGImage
                                                        scale: 1.0
                                                  orientation: UIImageOrientationUp];
            break;
        case UIImageOrientationUp:
            _adjustedImage = [[UIImage alloc] initWithCGImage: _adjustedImage.CGImage
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
    BOOL edited;
    if ([self.viewCrop frameEdited])
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
        cv::Mat original = [MAOpenCV cvMatFromUIImage:_adjustedImage];
        cv::warpPerspective(original, undistorted, cv::getPerspectiveTransform(src, dst), cvSize(maxWidth, maxHeight));
        original.release();
        
        _adjustedImage = [MAOpenCV UIImageFromCVMat:undistorted];
        undistorted.release();
        edited = YES;
    }
    else
    {
        edited = NO;
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
    
}

- (IBAction)editAction:(id)sender
{
    if (EditActionTagCrop == [sender tag]) {
        self.viewCrop.hidden = NO;
    }else{
        self.viewCrop.hidden = YES;
        [self confirmedImage];
        if (!self.firstCrop) {
            self.firstCrop = YES;
            [self adjustPreviewImage:2];
        }
    }
    self.viewScratchStroke.hidden == EditActionTagScatch != [sender tag];
    switch ([sender tag]) {
        case EditActionTagScatch:
        {
            [self adjustPreviewImage:4];
            break;
        }
        case EditActionTagRecover:
        {
            
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
            break;
        }
        case EditActionTagSave:
        {
            
            break;
        }
        default:
            break;
    }
}

@end
