//
//  CTHCreateQuestionUtilities.m
//  PRJCTH
//
//  Created by linjinxing on 16/2/4.
//  Copyright © 2016年 CTH. All rights reserved.
//

#import "CTHCreateQuestionUtilities.h"
#import "ToolManager.h"

@implementation CTHCreateQuestionUtilities

+ (void)uploadVoiceData:(NSData*)data withName:(NSString*)name{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = nil;
    NSString* dataPath = @"http://www.51cth.com/LoginServer/voiceFileUploadServlet";
    NSLog(@"上传声音：%@", dataPath);

    [manager POST:dataPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"voiceUrl" fileName:name mimeType:@"application/octet-stream"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上传声音成功 ==%@ %@",operation.responseObject,  operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传声音失败==%@ %@",operation.responseObject,  operation.responseString);
        NSLog(@"上传声音失败= %@",error.description);
    }];
}
@end
