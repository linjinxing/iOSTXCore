//
//  CTHImageViewController.m
//  PRJCTH
//
//  Created by linjinxing on 16/2/3.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "CTHImageViewController.h"

@interface CTHImageViewController()
@property(nonatomic, weak) IBOutlet UIImageView* imageView;
@end

@implementation CTHImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.image;
    self.image = nil;
    
    @weakify(self)
    [[self.view rac_signalForSelector:@selector(pointInside:withEvent:)] subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



@end
