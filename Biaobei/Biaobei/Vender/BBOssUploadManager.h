//
//  BBOssUploadManager.h
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/24.
//  Copyright © 2019 文亮. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OSSAuthModel : BaseBeanModel

@property (nonatomic, assign) BOOL getSucceed;
@property (nonatomic, copy) NSString *accessKeyId;
@property (nonatomic, copy) NSString *accessKeySecret;
@property (nonatomic, copy) NSString *securityToken;
@property (nonatomic, copy) NSString *folder; //文件夹 (这里写死为 image)
@property (nonatomic, copy) NSString *domain; //域名   (这里写死为@"http://allmantask.oss-cn-beijing.aliyuncs.com")   暂时无用

@end


/// 上传回调
typedef void(^uploadCallblock)(BOOL success, NSString* msg, NSArray<NSString *>* keys);

@interface BBOssUploadManager : NSObject

+(instancetype)sharedInstance;

@property (nonatomic, copy) NSString *contentUrl;  //文件路径

/// 上传图片
- (void)uploadImages:(NSArray *)images isAsync:(BOOL)isAsync callback:(uploadCallblock)callback;

/// 上传音频
- (void)asyncUploadAudio:(NSData *)data callback:(uploadCallblock)callback;

@end

