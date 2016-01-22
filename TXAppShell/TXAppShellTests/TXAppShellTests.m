//
//  TXAppShellTests.m
//  TXAppShellTests
//
//  Created by tongxing on 16/1/21.
//  Copyright © 2016年 tongxing. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TXAppShellTests : XCTestCase

@end

@implementation TXAppShellTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/**
 *  2.1 上传错题接口：{"dataType":"uploadTopic”,”topicInfo”:{“id”:2,”voiceMsgUrl":"1444891977468.amr","topicurl":"12015-10-15-14-52-26","topicImg":null,"answerImg":null,"subjecttype":"math","importance":"三颗星","surmmarize":null,"createTime":1444891985664,"lastModify":null,"topicUploaded":0,"answerUploaded":0,"isParentTopic":0,"topicCategory":"singleOption","answerurl":null,"userid":1,"textanswer":"C","topictype":"难点题","knowledgepoint":"映射概念","faultanilysis":"思路错误","errornum":1,"voiceMsgTime":"3","topicSource":"模拟考试","isDraft":0}}
 
 使用实例: http://112.126.80.207:8016/LoginServer/appServlet?params={"dataType":"uploadTopic","topicInfo":{"lastmodify":1445325642665,"faultanilysis":"知识错误","topicUploaded":0,"createTime":1445325642665,"knowledgepoint":"名篇","subjecttype":"chinese","topicSource":"期中考试","userid":1,"errornum":1,"textanswer":"C","isDraft":0,"importance":"四颗星","anwserUploaded":0,"topicurl":"12015-10-20-15-20-08","topicCategory":"singleOption","topictype":"难点题","isParentTopic":0}}
 */
- (void)testAddErrorQuestion {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
