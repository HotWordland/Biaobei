//
//  BBMineDetailBeanModel.h
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseBeanModel.h"

@interface BBMineDetailBeanModel : BaseBeanModel
@property (nonatomic, strong) NSString<Optional> * title;
@property (nonatomic, assign) NSInteger row;//第几个
@property (nonatomic, strong) NSString<Optional> * summary;
@property (nonatomic, strong) NSString<Optional> * imageName;
@property (nonatomic, strong) NSString<Optional> * placeHold;
@property (nonatomic, strong) NSString<Optional> * textField;
@property (nonatomic, assign) int textLength;

@property (nonatomic, copy) NSString *rec_id;  //重新录制的id(后台返的) 与原DB中subtaskID不一样

@property (nonatomic, strong) UIColor * summaryColor;

@property (nonatomic, assign) BOOL noTap;

@end

