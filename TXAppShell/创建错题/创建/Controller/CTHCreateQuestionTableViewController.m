//
//  CTHCreateQuestionTableViewController.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/23.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "CTHCreateQuestionTableViewController.h"
#import "CTHQuestionTagsSelectionViewController.h"
#import "TopicDetailViewController.h"
#import "CTHQuestionTagItem.h"
#import "TXRecordVoice.h"
#import "VoiceConverter.h"
#import "MAImagePickerController.h"
#import "CTHShareViewController.h"
#import "CTHImageViewController.h"
#import "CTHUpdateMeterView.h"
#import "CTHImageUtilities.h"
#import "CTHCreateQuestionUtilities.h"
#import "RequestModel.h"
#import "CTHQuestionTagItem.h"
#import "TXUIKit.h"
#import "UserManager.h"
#import "DBManager.h"

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
@property(weak) IBOutlet CTHUpdateMeterView* recorderMeterView;  /* 录音声音大小 */
@property(weak) IBOutlet UITextView* tfComment;  /* 备注 */
@property(weak) IBOutlet UITextView* tfAnswer;   /* 答案 */
@property(weak) IBOutlet UIImageView* imageViewVoiceSpeaker; /* 播放声音的image view */

@property(strong) IBOutletCollection(UICollectionView) NSArray* collectionViews; /* 所有的collection view */
@property(strong) IBOutletCollection(UIImageView) NSArray* imageViewStars; /* 重要程度 */

@property(assign) CommentInputType commentType; /* 备注的输入方式 */
@property(assign) NSUInteger importantLevel; /* 重要程度 */

@property(strong) NSMutableArray* arrayQuestionImagesPath; /* 题目拍摄的图片 */
@property(strong) NSMutableArray* arrayAnswerAnalysisImagesPath;   /* 答案拍摄的图片 */
@property(strong) NSMutableSet* setAnswer;   /* 答案 */
@property(strong) NSArray* arrayKnowledgePoints;    /* 知识点 */
@property(strong) NSArray* arrayTagItems;           /* 标签 */
@property(strong) TXRecordVoice* recorder;
@property(strong) NSString* recorderVoicePath;  /* amr 声音保存的路径 */
@property(strong) UILabel* labelForCalculateHeight; /* 专门用于计算高度 */
@end

@implementation CTHCreateQuestionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelForCalculateHeight = [[UILabel alloc] init];
    self.arrayQuestionImagesPath = [NSMutableArray arrayWithCapacity:3];
    self.arrayAnswerAnalysisImagesPath = [NSMutableArray arrayWithCapacity:3];
    self.setAnswer = [NSMutableSet setWithCapacity:10];
    self.imageViewVoiceSpeaker.animationImages = [[@[@"sound6", @"sound7", @"sound8"].rac_sequence map:^id(id value) {
        return [UIImage imageNamed:value];
    }] array];
    self.imageViewVoiceSpeaker.animationDuration = 1.0f;
    
    RAC(self.labelSubject, text) = RACObserve(self, subject.subjectName);
    RAC(self.labelType, text) = RACObserve(self, type);
    self.viewBottom.width = self.view.width;
    self.commentType = CommentInputTypeVoice;
    
    @weakify(self)  /* 重要程度 */
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
    
    /* 获取知识点 */
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"CHANGETABLEVIEW" object:nil]
     subscribeNext:^(NSNotification* noti) {
         @strongify(self)
         self.arrayKnowledgePoints = [noti.object[@"str"] componentsSeparatedByString:@","];
         [self.tableView reloadData];
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
    if ([vc isKindOfClass:[CTHQuestionTagsSelectionViewController class]]) {
        CTHQuestionTagsSelectionViewController* tagsVC = (CTHQuestionTagsSelectionViewController*)vc;
        tagsVC.subject = self.subject;
        @weakify(self)
        tagsVC.doneBlock = ^(NSArray* result, NSError* error){
            @strongify(self)
            self.arrayTagItems = result;
            [self.tableView reloadData];
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

- (RACSignal*)signalForSaveDatabaseWithParam:(NSDictionary*)param
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if( [[DBManager getInstance] insertIntoDataNyTopicModel:[TopicModel topicModelWithDictionary:param]]){
            [subscriber sendCompleted];
        }else{
            [subscriber sendError:[NSError errorWithDomain:@"com.cth" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"保存数据到本地失败!"}]];
        }
        return nil;
    }];
}

- (void)saveWithDismiss:(LJXBlock)dismiss
{
    [self updateImageAndVoiceIfNeed];
    NSMutableDictionary* param = [self getAllDataParam];
    
    [[CTHURLJSONConnectionCreateSignal(@{@"dataType":@"uploadTopic",@"topicInfo":param},@"result",nil)
      flattenMap:^RACStream *(id value) {
          NSLog(@"value:%@", value);
          param[@"Id"] = value;
          return [self signalForSaveDatabaseWithParam:param];
      }]
     subscribeError:^(NSError *error) {
         [self showHUDAndHidWithStr:@"保存失败"];
     } completed:^{
         [self showHUDAndHidWithStr:@"保存成功"];
         [self dismissViewControllerAnimated:YES completion:dismiss];
     }];
}

#pragma mark - 按钮手势等响应
- (IBAction)selectAnswerAction:(id)sender
{
    if ([sender isSelected]) {
        [self.setAnswer removeObject:[self anwsers][[sender tag]]];
    }else{
        [self.setAnswer addObject:[self anwsers][[sender tag]]];
    }
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray*)updateImageAndVoiceIfNeed
{
    RequestModel* model = [[RequestModel alloc] init];
    NSArray* imagePaths = [self.arrayQuestionImagesPath arrayByAddingObjectsFromArray:self.arrayAnswerAnalysisImagesPath];
    for (NSString* imagePath in imagePaths)
    {
        [model uploadTopicPicture:[NSData dataWithContentsOfFile:imagePath] andUrl:[imagePath lastPathComponent]];
    }
    if (self.recorderVoicePath){
        [CTHCreateQuestionUtilities uploadVoiceData:[NSData dataWithContentsOfFile:self.recorderVoicePath] withName:[self.recorderVoicePath lastPathComponent]];
    }
    return imagePaths;
}

- (NSMutableDictionary*)getAllDataParam
{
    NSString*(^getImageNames)(NSArray*) = ^(NSArray*imagePaths){
        return [[[imagePaths.rac_sequence
                  map:^id(id value) {
                    return [[value lastPathComponent] stringByDeletingPathExtension];
                  }]
                  array]
                  componentsJoinedByString:@","];
    };
    
    BOOL isSelectedQuestion = [self.type isEqualToString:@"选择题"];
    
    /* 多个全部逗号分割 */
    NSDictionary* info = @{
                           @"id": @0,
                           @"topicurl":getImageNames(self.arrayQuestionImagesPath), /* 题干图片 */
                           @"subjecttype":self.subject.subjectType,
                           @"importance":@[@"一颗星", @"二颗星", @"三颗星", @"四颗星", @"五颗星"][self.importantLevel],
                           //          @"surmmarize": null,
                           @"createTime": @([[NSDate date] timeIntervalSince1970]),
                           //          @"lastModify": null,
                           @"topicUploaded": @0,
                           @"answerUploaded": @0,
                           @"isParentTopic": @0, /* 1是家长拍摄，0学生 */
                           @"topicCategory": isSelectedQuestion ? @"singleOption" : @"otherOption", /* 选择题或者输入题 */
                           @"userid": @([UserManager getPupilId]),
                           @"textanswer": isSelectedQuestion ? [self.setAnswer.allObjects componentsJoinedByString:@","] : self.tfAnswer.text,  /* 答案文本 */
                           @"errornum": @1,
                           @"isDraft": @0
                           };
    NSMutableDictionary* dictParam = [NSMutableDictionary dictionaryWithDictionary:info];
    if ([self.arrayAnswerAnalysisImagesPath count]){ /* 答案图片 */
        dictParam[@"answerurl"] = getImageNames(self.arrayAnswerAnalysisImagesPath);
    }
    if ([self.arrayKnowledgePoints count]){
        dictParam[@"knowledgepoint"] = [self.arrayKnowledgePoints componentsJoinedByString:@","];
    }
    if ([self.recorderVoicePath length])
    {
        dictParam[@"voiceMsgUrl"] = self.recorderVoicePath;
        dictParam[@"voiceMsgTime"] = LJXNSStringFromNSNumber(@(self.recorder.duration));
    }
    
    void(^addTagsIfNotNone)(CTHQuestionTagTypes, NSString*) = ^(CTHQuestionTagTypes type, NSString* key){
        NSString* str = [[[[self.arrayTagItems.rac_sequence
                           filter:^BOOL(CTHQuestionTagItem* item) {
                               return (type == [item.tagTypeId integerValue]);
                           }]
                           map:^id(CTHQuestionTagItem* item) {
                              return item.topicTag;
                           }]
                           array]
                           componentsJoinedByString:@","];
        if ([str length]) {
            dictParam[key] = str;
        }
    };
    addTagsIfNotNone(CTHQuestionTagTypeType, @"topictype");
    addTagsIfNotNone(CTHQuestionTagTypeFrom, @"topicSource");
    addTagsIfNotNone(CTHQuestionTagTypeAnalysis, @"faultanilysis");
    addTagsIfNotNone(CTHQuestionTagTypeCustom, @"topicTag");
    
    return dictParam;
}

- (IBAction)continueToAdd:(id)sender
{
    [self save:sender];
    [[self class] prsentInStoryboard:@"CreateWrongQuestions"];
}

- (IBAction)saveDraft:(id)sender
{
    NSMutableDictionary* param = [self getAllDataParam];
    param[@"isDraft"] = @1;
    [[self signalForSaveDatabaseWithParam:param]
     subscribeError:^(NSError *error) {
        [self showHUDAndHidWithStr:@"保存失败!"];
    } completed:^{
        [self showHUDAndHidWithStr:@"保存成功!"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)save:(id)sender /* 保存 */
{
    [self saveWithDismiss:nil];
}

- (IBAction)switchCommentType:(id)sender
{
    self.commentType = (CommentInputType)[sender tag];
    [self.tableView reloadData];
}

- (IBAction)saveAndShare:(id)sender
{
#if defined(DEBUG) && 0
    CTHShareViewController* vc = (CTHShareViewController*)[CTHShareViewController prsentInStoryboard:@"CreateWrongQuestions"];
    vc.image = [UIImage imageWithContentsOfFile:self.arrayQuestionImagesPath[0]];
#else
    [self saveWithDismiss:^{
            CTHShareViewController* vc = (CTHShareViewController*)[CTHShareViewController instantiateViewControllerInStoryboard:@"CreateWrongQuestions"];
            vc.image = [UIImage imageWithContentsOfFile:self.arrayQuestionImagesPath[0]];
        [LJXUIGetTopViewController() presentViewControllerWithTransparentBackgroud:vc];
    }];
#endif
}

#pragma mark - 录音

- (IBAction)longPressVoiceRecordButtonAction:(UILongPressGestureRecognizer*)longPressedRecognizer
{
//    LJXLogObject(longPressedRecognizer);
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        LJXFoundationLog("record start");
        self.recorder = [[TXRecordVoice alloc] init];
        @weakify(self)
        self.recorder.updateMeter = ^(CGFloat meter){
            @strongify(self)
            NSLog(@"meter:%@, int:%@", @(meter), @((NSUInteger)roundf(meter*10)));
            [self.recorderMeterView setMeter:(NSUInteger)roundf(meter*10)];
        };
        [self.recorder startRecording];
        [self.recorderMeterView removeFromSuperview];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = self.recorderMeterView;
    }//长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded
            || longPressedRecognizer.state == UIGestureRecognizerStateCancelled){
        LJXFoundationLog("record end");
        [self.recorder stopRecording];
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        self.labelVoiceLength.text = [NSString stringWithFormat:@"%.01f\"", self.recorder.duration];
        self.recorderVoicePath = [[LJXPath document] stringByAppendingPathComponent:[LJXNSStringFromNSNumber(@([[NSDate date] timeIntervalSince1970])) stringByAppendingString:@".amr"]];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        LJXPerformBlockAsyn(^{
            [VoiceConverter wavToAmr:self.recorder.filePath amrSavePath:self.recorderVoicePath];
        });
    }
}

- (IBAction)playVoiceAction:(id)sender
{
    LJXLogFunction;
    [self.recorder play];
    [self.imageViewVoiceSpeaker stopAnimating];
    [self.imageViewVoiceSpeaker startAnimating];
    @weakify(self)
    self.recorder.playbackDidFinish = ^{
        @strongify(self)
        [self.imageViewVoiceSpeaker stopAnimating];
    };
}


- (void)addImageWithSuccess:(MAImagePickerDidFinish) didFinish
{
    NSString* camera = nil;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        camera = @"拍照";
    }
    UIActionSheet* as = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", camera, nil];
    NSInteger cancelIdx = as.cancelButtonIndex;
    @weakify(self)
    [[as rac_buttonClickedSignal] subscribeNext:^(id idx) {
        @strongify(self)
        NSInteger clickedIdx = [idx integerValue];
        if (cancelIdx != clickedIdx) {
            MAImagePickerController *imagePicker = [[MAImagePickerController alloc] init];
            imagePicker.didFinish = didFinish;
            imagePicker.sourceType = 0 == [idx integerValue] ? MAImagePickerControllerSourceTypePhotoLibrary : MAImagePickerControllerSourceTypeCamera;
            @weakify(imagePicker)
            imagePicker.didCancel = ^{
                @strongify(imagePicker)
                [imagePicker dismissViewControllerAnimated:YES completion:nil];
            };
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePicker];
            
            [self presentViewController:navigationController animated:YES completion:nil];
        }
    }];
    [as showInView:self.view];
}

#pragma mark -
- (NSArray*)datasForTag:(CollectionViewTag)tag
{
    return (CollectionViewTagKnowledgePoints == tag ? self.arrayKnowledgePoints : [[[self.arrayTagItems rac_sequence] map:^id(CTHQuestionTagItem* item) {
        return [item topicTag];
    }] array]);
}

- (CGFloat)calculateHeight:(CollectionViewTag)tag
{
    UICollectionView* cv = self.collectionViews[tag];
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)[cv collectionViewLayout];
    NSArray* datas = [self datasForTag:tag];
    CGSize contentSize = CGSizeMake(cv.width, layout.sectionInset.top);
    CGFloat maxWidth = cv.width - layout.sectionInset.left - layout.sectionInset.right;
    CGFloat width = .0f;
    for (NSUInteger i = 0; i < datas.count; ++i) {
        CGSize itemSize = [self collectionView:cv layout:layout sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        CGFloat tmpWidth = width + itemSize.width + layout.minimumInteritemSpacing;
        if (tmpWidth > maxWidth) {
            tmpWidth = width + itemSize.width;
            if (tmpWidth > maxWidth) { /* 要移动到下一行 */
                contentSize.height += (itemSize.height + layout.minimumLineSpacing);
                width = itemSize.width + layout.minimumInteritemSpacing;
            }else{
                width = tmpWidth; /* 如果是最右边那个，并且没有超过最大宽度，还在这行 */
            }
        }else{
            width = tmpWidth;
            if (LJXFloatIsEqual(contentSize.height, layout.sectionInset.top)) {
                contentSize.height += itemSize.height+ layout.minimumInteritemSpacing; /* 初始的时候要加个高度 */
            }
        }
    }
    contentSize.height += (layout.sectionInset.bottom);
    return contentSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section){
        /* 答案输入所在的cell是第1行， 当是选择题时返回0 */
        if  (1 == indexPath.row && [self.type isEqualToString:@"选择题"]) return .0f;
        if  (2 == indexPath.row && ![self.type isEqualToString:@"选择题"]) return .0f;
    }
    if (2 == indexPath.section){
        if  (1 == indexPath.row) {
            NSArray* datas = [self datasForTag:CollectionViewTagKnowledgePoints];
            return datas.count ? [self calculateHeight:CollectionViewTagKnowledgePoints] : .0f;
        }
        if  (3 == indexPath.row) {
            NSArray* datas = [self datasForTag:CollectionViewTagTags];
            return datas.count ? [self calculateHeight:CollectionViewTagTags] : .0f;
        }
        if  (5 == indexPath.row && CommentInputTypeText == self.commentType) return .0f;
        if  (6 == indexPath.row && CommentInputTypeVoice == self.commentType) return .0f;
        if  (7 == indexPath.row && 0 == self.recorderVoicePath.length) return .0f;
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
            UIButton* btn = [cell.contentView buttonWithTag:1];
            [btn setTitle:[self anwsers][indexPath.item] forState:UIControlStateNormal];
            btn.tag = indexPath.item;
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
        default:
            return [[UICollectionViewCell alloc] init];
    };
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (CollectionViewTagKnowledgePoints == collectionView.tag
        || CollectionViewTagTags == collectionView.tag) {
        UILabel* label = self.labelForCalculateHeight;
        NSArray* datas = [self datasForTag:collectionView.tag];
        label.text = datas[indexPath.item];
        [label sizeToFit];
        CGSize size = label.frame.size;
        size.height += 8;
        size.width += 16;
        return size;
    }
    //    NSLog(@"[%@], tag:%@, size:%@, indexPath:%@", NSStringFromSelector(_cmd), @(collectionView.tag), NSStringFromCGSize(size), indexPath);
    return CollectionViewTagAnswer == collectionView.tag ? CGSizeMake(32.0f, 32.0f) : CGSizeMake(100.0f, 100.0f);
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
            NSString* path = [image save2TempWithName:[CTHImageUtilities topicUrl]];
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
    }else{
        if (CollectionViewTagQuestion == collectionView.tag
            || CollectionViewTagAnalysis == collectionView.tag) {
        CTHImageViewController* imageVC = (CTHImageViewController*)[CTHImageViewController instantiateViewControllerInStoryboard:@"CreateWrongQuestions"];
            NSArray* imagePaths = CollectionViewTagQuestion == collectionView.tag ? self.arrayQuestionImagesPath : self.arrayAnswerAnalysisImagesPath;
            imageVC.image = [UIImage imageWithContentsOfFile:imagePaths[indexPath.item]];
            [self.navigationController pushViewController:imageVC animated:YES];
        }
    }
}

@end
