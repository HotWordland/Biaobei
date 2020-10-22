//
//  UnqualifiedBeanModel.h
//  Biaobei
//
//  Created by 王家辉 on 2019/11/14.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnqualifiedBeanModel : BaseBeanModel
@property (nonatomic, strong) NSString<Optional> * selectImageName;
@property (nonatomic, strong) NSString<Optional> * audioText;
@property (nonatomic, strong) NSString<Optional> * recordedImageName;
@property (nonatomic, strong) NSString<Optional> * audioUrl;  //阿里云URL
@property (nonatomic, strong) NSString<Optional> * audioId;  



@property (nonatomic, copy) NSString *rec_id;  //重新录制的id(后台返的) 与原DB中subtaskID不一样
@property (nonatomic, assign) BOOL noTap;

@end

NS_ASSUME_NONNULL_END
