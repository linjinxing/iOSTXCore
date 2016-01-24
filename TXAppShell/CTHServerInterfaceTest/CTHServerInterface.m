//
//  CTHServerInterface.m
//  TXAppShell
//
//  Created by linjinxing on 16/1/21.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import "CTHServerInterface.h"
#import "CTHSubject.h"
#import "CTHKnowledgePoint.h"
#import "CTHQuestionTagItem.h"
#import "CTHQuestiontags.h"

@implementation CTHServerInterface
+ (void)load
{
    
//    [self testQuestionAllTags];
}

+ (void)testSubject
{
    [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"getSubjects",@"userId":@"1"}, @"subjects", [CTHSubject class])
     subscribeNext:^(id x) {
         LJXLogObject(x);
     } error:^(NSError *error) {
         LJXNSError(error);
     }];
}

+ (void)testKnowledgePoints
{
    [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"getKnowledgePoints",@"subjectType":@"math"}, @"knowledgePoints", [CTHKnowledgePoint class])
     subscribeNext:^(id x) {
         LJXLogObject(x);
     } error:^(NSError *error) {
         LJXNSError(error);
     }];
}

+ (void)testQuestionAllTags
{
   [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"getTagInfos",@"subjectType":@"chinese",@"userName":@"linjinxing"}, @"result", [CTHQuestionTags class])
     subscribeNext:^(id x) {
         LJXLogObject(x);
     } error:^(NSError *error) {
         LJXNSError(error);
     }];
}

+ (void)testQuestionTags
{
    [CTHURLJSONConnectionCreateSignal(@{@"dataType":@"getTagInfosByType",@"tagTypeId":@"11",@"subjectType":@"math",@"userName":@"天空之城"}, @"result.tags", [CTHQuestionTagItem class])
     subscribeNext:^(id x) {
         LJXLogObject(x);
     } error:^(NSError *error) {
         LJXNSError(error);
     }];
}


@end
