//
//  CarouselsCollectionViewCell.m
//  Biaobei
//
//  Created by 王家辉 on 2019/11/20.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "CarouselsCollectionViewCell.h"

@implementation CarouselsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    self.contentView.backgroundColor = [UIColor clearColor];
    _imageView = [UIImageView new];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 51, 182, 22)];
    _titleLabel.numberOfLines = 2;
    _titleLabel.font = kFontMediumSize(20);
    _titleLabel.textColor = GreenColor;
    _titleLabel.numberOfLines = 1;

    CGRect tRect = CGRectMake(25, _titleLabel.bottom + 9, 178, 14);
    _typeLabel = [[UILabel alloc]initWithFrame:tRect];
    
    CGRect pRect = CGRectMake(SCREENWIDTH - 24 - 40, 1, 24, 54);
    _promptImageView = [[UIImageView alloc] initWithFrame:pRect];  //加急

    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_typeLabel];
    [self.contentView addSubview:_promptImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
}
@end
