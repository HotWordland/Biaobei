//
//  BBMineDetailView.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/5.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBMineDetailView.h"

@interface BBMineDetailView()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UILabel * summaryLabel;
@property (nonatomic, strong) UIImageView * imageView;
@end

@implementation BBMineDetailView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        [self layoutUI];
    }
    return  self;
}

-(void)prepareUI {
    self.titleLabel = [UILabel new];
    self.titleLabel.font = kFontMediumSize(17);
    self.titleLabel.textColor = [UIColor colorWithRed:51.0/255 green:57.0/255 blue:76.0/255 alpha:1];
    [self addSubview:self.titleLabel];
    self.summaryLabel = [UILabel new];
    self.summaryLabel.font = kFontRegularSize(16);
    self.summaryLabel.textColor = [UIColor colorWithRed:51.0/255 green:57.0/255 blue:76.0/255 alpha:1];
    self.summaryLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.summaryLabel];

    self.textField = [UITextField new];
    self.textField.font = kFontRegularSize(16);
    self.textField.textAlignment = NSTextAlignmentRight;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.textField];

    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
}

-(void)layoutUI {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.height.mas_equalTo(18);
        make.right.mas_lessThanOrEqualTo(-18);
        make.centerY.equalTo(self.mas_centerY);
    }];

    [self.summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
        make.right.equalTo(self.imageView.mas_left).offset(-10);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.mas_equalTo(16);
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.titleLabel.mas_right).offset(10);
        make.right.equalTo(self.imageView.mas_left).offset(-10);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.height.mas_equalTo(20);
    }];

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-18);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
    }];
}

-(void)setModel:(BBMineDetailBeanModel *)model {
    _model = model;
    [self updateUI];
}

-(void)updateUI {
    self.titleLabel.text = self.model.title;
    self.summaryLabel.text = self.model.summary;
    if (self.model.summaryColor) {
        self.summaryLabel.textColor = self.model.summaryColor;
    }else{
        self.summaryLabel.textColor = [UIColor colorWithRed:51.0/255 green:57.0/255 blue:76.0/255 alpha:1];
    }
    if (self.model.placeHold.length > 0 ) {
        self.textField.placeholder = self.model.placeHold;
        if (self.model.textField) {
            self.textField.text = self.model.textField;
        }
        self.textField.hidden = NO;
        self.summaryLabel.hidden = YES;
    } else {
        self.textField.hidden = YES;
        self.summaryLabel.hidden = NO;
    }

    if (self.model.imageName) {
        self.imageView.image = [UIImage imageNamed:self.model.imageName];
    }
    if (!self.model || self.model.imageName.length == 0) {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.right.mas_equalTo(-8);
        }];
    } else if ([self.model.imageName isEqualToString:@"Mine_Right_direct"]) {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(6);
            make.right.mas_equalTo(-18);
            make.height.mas_equalTo(12);
        }];
    } else {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(12);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(16);
        }];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.model.textField = textField.text;
}

-(void)textChange:(UITextField *)textField {
    if (self.model.textLength>0) {
        if (textField.text.length>self.model.textLength) {
            NSString *text = textField.text;
            text = [text substringToIndex:self.model.textLength];
            textField.text = text;
        }
    }
    self.model.textField = textField.text;
}

@end
