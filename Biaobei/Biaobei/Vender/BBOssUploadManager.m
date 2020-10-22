//
//  BBOssUploadManager.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/24.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBOssUploadManager.h"
#import <AliyunOSSiOS/OSSService.h>

#define kOSSEndpoint @"http://oss-cn-beijing.aliyuncs.com"
#define kOSSBucketName @"allmantask"
#define kOSSDomin @"http://allmantask.oss-cn-beijing.aliyuncs.com"

@implementation OSSAuthModel

@end

@implementation BBOssUploadManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static BBOssUploadManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BBOssUploadManager alloc] init];
    });
    return sharedInstance;
}

/// 上传图片
- (void)uploadImages:(NSArray *)images isAsync:(BOOL)isAsync callback:(uploadCallblock)callback {
    
    // 1
    [self getOSSAuth:^(OSSAuthModel *OSSAuth) {
        if (!OSSAuth.getSucceed) {
            if (callback) callback(NO ,@"获取上传token失败", nil);
            return ;
        }
        
        // 2
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:OSSAuth.accessKeyId secretKeyId:OSSAuth.accessKeySecret securityToken:OSSAuth.securityToken];
        
        OSSClient *client = [[OSSClient alloc] initWithEndpoint:kOSSEndpoint credentialProvider:credential];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = images.count;
        
        NSMutableArray *callBackNames = [NSMutableArray array];
        int i = 0;
        for (UIImage *image in images) {
            if (image) {
                NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                    //任务执行
                    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                    put.bucketName = kOSSBucketName;
                    
                    NSString *imageName = [NSString stringWithFormat:@"%@/%@", OSSAuth.folder,[NSString randomStringWithLength:8]];
                    NSString *suffix = [NSString stringWithFormat:@"-%zdx%zd.png", (NSInteger)image.size.width,(NSInteger)image.size.height];
                    imageName = [imageName stringByAppendingString:suffix];
                    
                    put.objectKey = imageName;
                    
                    // 传出url
//                    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", OSSAuth.domain,imageName];
//
//                    [callBackNames addObject:imageUrl];
                    
                    NSData *data = UIImageJPEGRepresentation(image, 0.5);
                    put.uploadingData = data;
                    
                    OSSTask * putTask = [client putObject:put];
                    [putTask waitUntilFinished]; // 阻塞直到上传完成
                    
                    if (!putTask.error) {
                        NSLog(@"upload object success! \nimageName:%@\n", imageName);
                    } else {
                        NSLog(@"upload object failed, error: %@" , putTask.error);
                    }
                    
                    //上传成功后获取url
                    NSString * constrainURL = nil;
                    // sign constrain url
                    OSSTask * task = [client presignConstrainURLWithBucketName:kOSSBucketName
                                                                 withObjectKey:imageName
                                                        withExpirationInterval: 3*365*24*60*60];
                    if (!task.error) {
                        constrainURL = task.result;
                        if (self.contentUrl) {
                            constrainURL = imageName;
                        }
                        [callBackNames addObject:constrainURL];
                    } else {
                        NSLog(@"error: %@", task.error);
                    }
                    
                    if (isAsync) {
                        if (image == images.lastObject) {
                            NSLog(@"upload object finished!");
                            if (callback) {
                                callback( YES, @"全部上传完成" , [callBackNames copy]);
                            }
                        }
                    }
                }];
                if (queue.operations.count != 0) {
                    [operation addDependency:queue.operations.lastObject];
                }
                [queue addOperation:operation];
            }
            i++;
        }
        if (!isAsync) {
            [queue waitUntilAllOperationsAreFinished];
            
            if (callback) {
                callback( YES, @"全部上传完成" , [callBackNames copy]);
            }
        }
    }];
}

/// 上传音频
- (void)asyncUploadAudio:(NSData *)data callback:(uploadCallblock)callback {
    
    // 1
    [self getOSSAuth:^(OSSAuthModel *OSSAuth) {
        if (!OSSAuth.getSucceed) {
            if (callback) callback(NO ,@"获取上传token失败" , nil);
            return ;
        }
        if (data.length > 52428800) {
            if (callback) callback(NO ,@"视频文件最大不能超过50M" , nil);
            return;
        }
        
        // 2
        id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:OSSAuth.accessKeyId secretKeyId:OSSAuth.accessKeySecret securityToken:OSSAuth.securityToken];
        
        OSSClient *client = [[OSSClient alloc] initWithEndpoint:kOSSEndpoint credentialProvider:credential];
        
        //任务执行
        OSSPutObjectRequest * put = [OSSPutObjectRequest new];
        put.bucketName = kOSSBucketName;
        
        NSString *audioName = [NSString stringWithFormat:@"%@/%@.wav", OSSAuth.folder,[NSString randomStringWithLength:8]];
        put.objectKey = audioName;
        
        // 3
        // 传出url
//        NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", OSSAuth.domain,imageName];
        
        put.uploadingData = data;
        
        OSSTask * putTask = [client putObject:put];
        [putTask waitUntilFinished]; // 阻塞直到上传完成
        
        //上传成功后获取url
        NSString * constrainURL = nil;
        // sign constrain url
        OSSTask * task = [client presignConstrainURLWithBucketName:kOSSBucketName
                                                     withObjectKey:audioName
                                            withExpirationInterval: 3*365*24*60*60];
        if (!task.error) {
            constrainURL = task.result;
            if (self.contentUrl) {
                constrainURL = audioName;
            }
        } else {
            NSLog(@"error: %@", task.error);
        }
        
        if (!putTask.error) {
            NSLog(@"upload object success!");
            if (callback)   callback( YES,  @"上传成功", @[constrainURL]);
        } else {
            NSLog(@"upload object failed, error: %@" , putTask.error);
            if (callback)   callback( NO,  @"上传失败", nil);
        }
    }];
}


-(void)getOSSAuth:(void(^)(OSSAuthModel *OSSAuth))result{
    
    OSSAuthModel *authModel = [[OSSAuthModel alloc]init];
    [[BBRequestManager sharedInstance] getOssTokenWithSuccess:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        NSDictionary *dataDic = responseObject[@"data"];
        authModel.accessKeyId = dataDic[@"accessKeyId"];
        authModel.accessKeySecret = dataDic[@"accessKeySecret"];
        authModel.securityToken = dataDic[@"securityToken"];
        authModel.getSucceed = YES;
        authModel.domain = kOSSDomin;
        authModel.folder = @"biaobei/upload";
        
        if (!String_IsEmpty(self.contentUrl)) {
            authModel.domain = @"";
            authModel.folder = self.contentUrl;
        }
        
        result(authModel);
    } failure:^(NSString * _Nonnull error) {
        authModel.getSucceed = NO;
        result(authModel);
    }];
    
}

@end
