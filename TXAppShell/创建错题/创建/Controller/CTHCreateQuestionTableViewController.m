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
#import "TXRecordVoice.h"
#import "VoiceConverter.h"
#import "MAImagePickerController.h"
#import "CTHShareViewController.h"
#import "TXUIKit.h"

enum CollectionViewTag{
    CollectionViewTagQuestion ,
    CollectionViewTagAnswer  ,
    CollectionViewTagAnalysis  ,
    CollectionViewTagKnowledgePoints  ,
    CollectionViewTagTags
};

@interface CTHCreateQuestionTableViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, MAImagePickerControllerDelegate>
@property(weak) IBOutlet UILabel* labelSubject;
@property(weak) IBOutlet UILabel* labelType;
@property(weak) IBOutlet UIView* viewBottom; /* 底部工具栏 */
@property(weak) IBOutlet UILabel* labelVoiceLength;
@property(strong) IBOutletCollection(UICollectionView) NSArray* collectionViews;
@property(strong) IBOutletCollection(UIImageView) NSArray* imageViewStars;
@property(strong) NSArray* arrayKnowledgePoints;
@property(strong) NSArray* arrayTagItems;
@property(strong) TXRecordVoice* recorder;
@end

@implementation CTHCreateQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelSubject.text = self.subject.subjectname;
    self.labelType.text = self.type;
    self.viewBottom.width = self.view.width;
    
    @weakify(self)
    for (UIImageView* imageView in self.imageViewStars) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
        [imageView addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer* gesture) {
            @strongify(self)
            for (int i = 0; i < self.imageViewStars.count; ++i) {
                [self.imageViewStars[i] setHighlighted:i <= gesture.view.tag];
            }
        }];
    }
    
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


- (IBAction)share:(id)sender
{
    
}

#pragma mark - 录音

- (IBAction)longPressVoiceRecordButtonAction:(UILongPressGestureRecognizer*)longPressedRecognizer
{
    if (nil == self.recorder) {
        self.recorder = [[TXRecordVoice alloc] init];
    }
    LJXLogObject(longPressedRecognizer);
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        LJXFoundationLog("record start");
        [self.recorder startRecording];
    }//长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled){
        LJXFoundationLog("record end");
        [self.recorder stopRecording];
        self.labelVoiceLength.text = [NSString stringWithFormat:@"%.01f\"", self.recorder.duration / 1000];
//        [VoiceConverter wavToAmr:self.recorder.filePath amrSavePath:[[LJXPath document] stringByAppendingPathComponent:@"tmp.amr"]];
    }
}

- (IBAction)playVoiceAction:(id)sender
{
    LJXLogFunction;
    [self.recorder play];
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

- (IBAction)addImage:(id)sender
{
    MAImagePickerController *imagePicker = [[MAImagePickerController alloc] init];
    
    [imagePicker setDelegate:self];
//    [imagePicker setSourceType:MAImagePickerControllerSourceTypeCamera];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)imagePickerDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerDidChooseImageWithPath:(NSString *)path
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSLog(@"File Found at %@", path);
        
    }
    else
    {
        NSLog(@"No File Found at %@", path);
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
