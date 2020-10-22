//
//  UnqualifiedView.m
//  Biaobei
//
//  Created by 王家辉 on 2019/11/14.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "UnqualifiedView.h"

@interface UnqualifiedView()
@property (nonatomic, strong) UILabel *audioTextLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIImageView *recordedImageView;
@end

@implementation UnqualifiedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        [self layoutUI];
    }
    return  self;
}

-(void)prepareUI {
    self.audioTextLabel = [[UILabel alloc] init];
    self.audioTextLabel.font = kFontMediumSize(17);
    self.audioTextLabel.textColor = [UIColor colorWithRed:51.0/255 green:57.0/255 blue:76.0/255 alpha:1];
    [self addSubview:self.audioTextLabel];

    self.selectedImageView = [[UIImageView alloc] init];
    [self addSubview:self.selectedImageView];
    self.recordedImageView = [[UIImageView alloc] init];
    [self addSubview:self.recordedImageView];
}

-(void)layoutUI {
    [self.audioTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(42);
        make.height.mas_equalTo(18);
        make.right.mas_lessThanOrEqualTo(-24);
        make.centerY.equalTo(self.mas_centerY);
    }];

    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.audioTextLabel.mas_centerY);
        make.width.mas_equalTo(18);
        make.height.mas_equalTo(18);
    }];
    
    [self.recordedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(28);
    }];
}

-(void)setModel:(UnqualifiedBeanModel *)model {
    _model = model;
    [self updateUI];
}

-(void)updateUI {
    self.audioTextLabel.text = self.model.audioText;
    
    
//    self.summaryLabel.text = self.model.summary;
//    if (self.model.summaryColor) {
//        self.summaryLabel.textColor = self.model.summaryColor;
//    }else{
//        self.summaryLabel.textColor = [UIColor colorWithRed:51.0/255 green:57.0/255 blue:76.0/255 alpha:1];
//    }
//    if (self.model.placeHold.length > 0 ) {
//        self.textField.placeholder = self.model.placeHold;
//        if (self.model.textField) {
//            self.textField.text = self.model.textField;
//        }
//        self.textField.hidden = NO;
//        self.summaryLabel.hidden = YES;
//    } else {
//        self.textField.hidden = YES;
//        self.summaryLabel.hidden = NO;
//    }
//
//    if (self.model.imageName) {
//        self.imageView.image = [UIImage imageNamed:self.model.imageName];
//    }
//    if (!self.model || self.model.imageName.length == 0) {
//        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(0);
//            make.right.mas_equalTo(-8);
//        }];
//    } else if ([self.model.imageName isEqualToString:@"Mine_Right_direct"]) {
//        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(6);
//            make.right.mas_equalTo(-18);
//            make.height.mas_equalTo(12);
//        }];
//    } else {
//        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(12);
//            make.right.mas_equalTo(-16);
//            make.height.mas_equalTo(16);
//        }];
//    }
    
        if (self.model.selectImageName) {
            self.selectedImageView.image = [UIImage imageNamed:self.model.selectImageName];
        }
        if (self.model.recordedImageName) {
            self.recordedImageView.image = [UIImage imageNamed:self.model.recordedImageName];
        }
    
//        [self.selectedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(12);
//            make.left.mas_equalTo(0);
//            make.height.mas_equalTo(12);
//        }];
//        [self.recordedImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo(10);
            //            make.left.mas_equalTo(0);
//            make.height.mas_equalTo(10);
//        }];
}



@end
