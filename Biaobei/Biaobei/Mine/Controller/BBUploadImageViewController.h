//
//  BBUploadImageViewController.h
//  Biaobei
//
//  Created by 文亮 on 2019/9/6.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^UpLoadImageBlock)(UIImage *image,NSString *imageUrl);

NS_ASSUME_NONNULL_BEGIN

@interface BBUploadImageViewController : BaseViewController

@property (nonatomic, copy) UpLoadImageBlock uploadImgBlock;
@property (nonatomic, strong) UIImage *upLoadImage;

@end

NS_ASSUME_NONNULL_END
