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
#import "CTHQuestionTagItem.h"

enum CollectionViewTag{
    CollectionViewTagQuestion ,
    CollectionViewTagAnswer  ,
    CollectionViewTagAnalysis  ,
    CollectionViewTagKnowledgePoints  ,
    CollectionViewTagTags
};

@interface CTHCreateQuestionTableViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(weak) IBOutlet UILabel* labelSubject;
@property(weak) IBOutlet UILabel* labelType;
@property(weak) IBOutlet UIView* viewBottom;
@property(strong) IBOutletCollection(UICollectionView) NSArray* collectionViews;
@property(strong) NSArray* arrayKnowledgePoints;
@property(strong) NSArray* arrayTagItems;
@end

@implementation CTHCreateQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelSubject.text = self.subject.subjectname;
    self.labelType.text = self.type;
    
    self.viewBottom.width = self.view.width;
    
    for (UICollectionView* cv in self.collectionViews) {
        cv.delegate = self;
        cv.dataSource  = self;
    }
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"CHANGETABLEVIEW" object:nil]
     subscribeNext:^(NSNotification* noti) {
         self.arrayKnowledgePoints = [noti.object[@"str"] componentsSeparatedByString:@","];
         [self.collectionViews[CollectionViewTagKnowledgePoints] reloadData];
         LJXLogObject(noti);
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
        CTHQuestionTagsTableViewController* tagsVC = (CTHQuestionTagsTableViewController*)vc;
        tagsVC.subject = self.subject;
        @weakify(self)
        tagsVC.doneBlock = ^(NSArray* result, NSError* error){
            @strongify(self)
            self.arrayTagItems = result;
           [self.collectionViews[CollectionViewTagTags] reloadData];
        };
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

#pragma mark - UICollectionView

#pragma mark - 题干

#pragma mark - 答案

static NSArray* const anwsers = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"];

#pragma mark - 解析

#pragma mark - 知识点

#pragma mark - 标签

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (collectionView.tag) {
        case CollectionViewTagAnswer: return anwsers.count;
        case CollectionViewTagKnowledgePoints: return self.arrayKnowledgePoints.count;
        case CollectionViewTagTags: return self.arrayTagItems.count;
        default:
            return 0;
    };
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* const reuseIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    switch (collectionView.tag) {
        case CollectionViewTagAnswer:
        {
            [[cell.contentView buttonWithTag:1] setTitle:anwsers[indexPath.item] forState:UIControlStateNormal];
            return cell;
        }
        case CollectionViewTagKnowledgePoints:
        {
            [cell.contentView labelWithTag:1].text = self.arrayKnowledgePoints[indexPath.item];
            return cell;
        }
        case CollectionViewTagTags:
        {
            [cell.contentView labelWithTag:1].text = [self.arrayTagItems[indexPath.item] topicTag];
            return cell;
        }
            break;
        default:
            return [[UICollectionViewCell alloc] init];
    };
};

@end
