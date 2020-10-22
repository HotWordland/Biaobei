//
//  BBCollectAudioViewCell.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/16.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBCollectAudioViewCell.h"

@implementation BBCollectAudioViewCell
{
    UIScrollView *bgScrollView;
    MLLabel *contentLabel;
    
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:@"#33394C"];
        
        self.layer.cornerRadius = 15;
        self.clipsToBounds = YES;
        
        float width = frame.size.width;
        float height = frame.size.height;
        
        bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        bgScrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:bgScrollView];
        
        contentLabel = [[MLLabel alloc]initWithFrame:CGRectMake(20, 20, width-35, 20)];
        contentLabel.font = kFontRegularSize(16);
        contentLabel.textColor = [UIColor colorWithHex:@"#8890A9"];
        contentLabel.lineSpacing = 5;
        [bgScrollView addSubview:contentLabel];
        
    }
    
    return self;
}


-(void)setAudioText:(NSString *)audioText{
    contentLabel.text = audioText;
    contentLabel.frame = contentLabel.frame;
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    
    bgScrollView.contentSize = CGSizeMake(self.width, contentLabel.bottom+5);
    
}

@end
