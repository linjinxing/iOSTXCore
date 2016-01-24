//
//  CTHCreateQuestionTableViewController.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "CTHCreateQuestionTableViewController.h"
#import "CTHQuestionTagsTableViewController.h"
#import "TopicDetailViewController.h"

@interface CTHCreateQuestionTableViewController ()
@property(weak) IBOutlet UILabel* labelSubject;
@property(weak) IBOutlet UILabel* labelType;
@property(weak) IBOutlet UIView* viewBottom;
@end

@implementation CTHCreateQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelSubject.text = self.subject.subjectname;
    self.labelType.text = self.type;
    
    self.viewBottom.width = self.view.width;
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"CHANGETABLEVIEW" object:nil]
     subscribeNext:^(id x) {
         LJXLogObject(x);
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController.toolbar addSubview:self.viewBottom];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController* vc = [segue destinationViewController];
    if ([vc isKindOfClass:[CTHQuestionTagsTableViewController class]]) {
        ((CTHQuestionTagsTableViewController*)vc).subject = self.subject;
    }
    if ([vc isKindOfClass:[TopicDetailViewController class]]) {
         TopicDetailViewController* topicDetail = (TopicDetailViewController*)vc;
        topicDetail.isFromeWrongAndAnsy = YES;
        topicDetail.object = self.subject.subjectname;
        topicDetail.i = 1;/* 代表知识点 */
        topicDetail.titleStr = @"选择知识点";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source


@end
