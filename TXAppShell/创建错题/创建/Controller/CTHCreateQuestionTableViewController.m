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

/* 判断是否是添加图片按键的IndexPath */
#define isAddImageIndexPath(indexPath,array) (indexPath.item >= array.count)

typedef enum tagCollectionViewTag{
    CollectionViewTagQuestion ,
    CollectionViewTagAnswer  ,
    CollectionViewTagAnalysis  ,
    CollectionViewTagKnowledgePoints  ,
    CollectionViewTagTags
}CollectionViewTag;

typedef enum tagCommentInputType{
  CommentInputTypeVoice = 5, /* CommentInputTypeVoice模式在tableview中的cell的indexpath.row一样，
                              比如声音按钮的tag必须是CommentInputTypeVoice的值，
                              键盘按钮的tag必须是CommentInputTypeText的值 */
 CommentInputTypeText
}CommentInputType;

@interface CTHCreateQuestionTableViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(weak) IBOutlet UILabel* labelSubject;
@property(weak) IBOutlet UILabel* labelType;
@property(weak) IBOutlet UIView* viewBottom; /* 底部工具栏 */
@property(weak) IBOutlet UILabel* labelVoiceLength;
@property(weak) IBOutlet UITextView* tfComment;  /* 备注 */
@property(weak) IBOutlet UITextView* tfAnswer;   /* 答案 */
@property(strong) IBOutletCollection(UICollectionView) NSArray* collectionViews;
@property(strong) IBOutletCollection(UIImageView) NSArray* imageViewStars;

@property(assign) CommentInputType commentType; /* 备注的输入方式 */
@property(assign) NSUInteger importantLevel; /* 重要程度 */

@property(strong) NSMutableArray* arrayQuestionImagesPath; /* 题目拍摄的图片 */
@property(strong) NSMutableArray* arrayAnswerAnalysisImagesPath;   /* 答案拍摄的图片 */
@property(strong) NSMutableArray* arrayAnswer;   /* 答案 */
@property(strong) NSArray* arrayKnowledgePoints;    /* 知识点 */
@property(strong) NSArray* arrayTagItems;           /* 标签 */
@property(strong) TXRecordVoice* recorder;
@property(strong) NSString* recorderVoicePath;  /* amr 声音保存的路径 */
@end

@implementation CTHCreateQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayQuestionImagesPath = [NSMutableArray arrayWithCapacity:3];
    self.arrayAnswerAnalysisImagesPath = [NSMutableArray arrayWithCapacity:3];
    self.arrayAnswer = [NSMutableArray arrayWithCapacity:10];
    
    self.labelSubject.text = self.subject.subjectName;
    self.labelType.text = self.type;
    self.viewBottom.width = self.view.width;
    self.commentType = CommentInputTypeVoice;
    
    @weakify(self)
    for (UIImageView* imageView in self.imageViewStars) {
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
        [imageView addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer* gesture) {
            @strongify(self)
            self.importantLevel = gesture.view.tag;
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
        topicDetail.object = self.subject.subjectName;
        topicDetail.i = 1;/* 代表知识点 */
        topicDetail.titleStr = @"选择知识点";
    }
}

#pragma mark - 按钮手势等响应

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)share:(id)sender
{
    
}

- (IBAction)switchCommentType:(id)sender
{
    self.commentType = [sender tag];
    [self.tableView reloadData];
}

#pragma mark - 录音

- (IBAction)longPressVoiceRecordButtonAction:(UILongPressGestureRecognizer*)longPressedRecognizer
{
    if (nil == self.recorder) {
        self.recorder = [[TXRecordVoice alloc] init];
    }
//    LJXLogObject(longPressedRecognizer);
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        LJXFoundationLog("record start");
        [self.recorder startRecording];
    }//长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled){
        LJXFoundationLog("record end");
        [self.recorder stopRecording];
        self.labelVoiceLength.text = [NSString stringWithFormat:@"%.01f\"", self.recorder.duration / 1000];
        self.recorderVoicePath = [[LJXPath document] stringByAppendingPathComponent:@"tmp.amr"];
        LJXPerformBlockAsyn(^{
            [VoiceConverter wavToAmr:self.recorder.filePath amrSavePath:self.recorderVoicePath];
        });
    }
}

- (IBAction)playVoiceAction:(id)sender
{
    LJXLogFunction;
    [self.recorder play];
}

#pragma mark -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section){
        /* 答案输入所在的cell是第1行， 当是选择题时返回0 */
        if  (1 == indexPath.row && [self.type isEqualToString:@"选择题"]) return .0f;
        if  (2 == indexPath.row && ![self.type isEqualToString:@"选择题"]) return .0f;
    }
    if (2 == indexPath.section){
        if  (5 == indexPath.row && CommentInputTypeText == self.commentType) return .0f;
        if  (6 == indexPath.row && CommentInputTypeVoice == self.commentType) return .0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - collection view

- (NSArray*) anwsers{
   return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (collectionView.tag) {
        case CollectionViewTagQuestion: return MIN(self.arrayQuestionImagesPath.count + 1, 3);
        case CollectionViewTagAnswer: return [self anwsers].count;
        case CollectionViewTagAnalysis: return MIN(self.arrayAnswerAnalysisImagesPath.count + 1, 3);
        case CollectionViewTagKnowledgePoints: return self.arrayKnowledgePoints.count;
        case CollectionViewTagTags: return self.arrayTagItems.count;
        default:
            return 0;
    };
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* const reuseIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    
    UICollectionViewCell*(^getCell)(NSMutableArray* ) = ^(NSMutableArray* imagePathes){
        if isAddImageIndexPath(indexPath, imagePathes){
            /* 添加图片 */
           return [collectionView dequeueReusableCellWithReuseIdentifier:@"Add" forIndexPath:indexPath];
        }else{
            /* 显示已经添加的图片 */
            [cell.contentView imageViewWithTag:1].image = [UIImage imageWithContentsOfFile:imagePathes[indexPath.item]];
            [[[cell.contentView buttonWithTag:2] rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [imagePathes removeObjectAtIndex:indexPath.item];
                [collectionView reloadData];
            }];
            return (__kindof UICollectionViewCell*) cell;
        }
    };
    
    switch (collectionView.tag) {
        case CollectionViewTagQuestion:
        {
            return getCell(self.arrayQuestionImagesPath);
        }
        case CollectionViewTagAnswer:
        {
            [[cell.contentView buttonWithTag:1] setTitle:[self anwsers][indexPath.item] forState:UIControlStateNormal];
            return cell;
        }
        case CollectionViewTagAnalysis:
        {
            return getCell(self.arrayAnswerAnalysisImagesPath);
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

- (void)addImageWithSuccess:(MAImagePickerDidFinish) didFinish
{
    MAImagePickerController *imagePicker = [[MAImagePickerController alloc] init];
    imagePicker.didFinish = didFinish;
    @weakify(imagePicker)
    imagePicker.didCancel = ^{
        @strongify(imagePicker)
        [imagePicker dismissViewControllerAnimated:YES completion:nil];
    };
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if  (
         (CollectionViewTagQuestion == collectionView.tag
         && isAddImageIndexPath(indexPath, self.arrayQuestionImagesPath))
         ||
         (CollectionViewTagAnalysis == collectionView.tag
             && isAddImageIndexPath(indexPath, self.arrayAnswerAnalysisImagesPath))
         )
    {
        @weakify(self)
        [self addImageWithSuccess:^(UIImage *image) {
            @strongify(self)
            NSString* path = [image save2TempWithName:[[NSDate date] description]];
            if (path)
            {
                if (CollectionViewTagQuestion == collectionView.tag) {
                    [self.arrayQuestionImagesPath insertObject:path atIndex:0];
                }else{
                    [self.arrayAnswerAnalysisImagesPath insertObject:path atIndex:0];
                }
                [collectionView reloadData];
            }else{
                LJXError("存储图片失败, image:%@", image);
            }
        }];
    }
}

@end
