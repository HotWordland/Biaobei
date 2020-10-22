//
//  BBGuideViewController.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/24.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBGuideViewController.h"
#import "BBLoginViewController.h"

@interface BBGuideViewController ()
{
    UIScrollView *guideScrollView;
}

@end

@implementation BBGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self createSubViews];
}

-(void)createSubViews{
    
    guideScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    guideScrollView.contentSize = CGSizeMake(SCREENWIDTH*5, SCREENHEIGHT);
    guideScrollView.showsHorizontalScrollIndicator = NO;
    guideScrollView.pagingEnabled = YES;
    guideScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:guideScrollView];
    
    
    float width = SCREENWIDTH;
    float height = SCREENHEIGHT;
    
    float imageScale = 1350.0/2436.0;
    float screenScale = SCREENWIDTH/SCREENHEIGHT;
    if (imageScale>screenScale) {
        height = width/imageScale;
    }else{
        width = height*imageScale;
    }
    
    for (int i=0; i<5; i++) {
        //CGRectMake(SCREENWIDTH*i+(SCREENWIDTH-width)/2, (SCREENHEIGHT-height)/2, width, height)
        //CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, SCREENHEIGHT)
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*i+(SCREENWIDTH-width)/2, (SCREENHEIGHT-height)/2, width, height)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
        [guideScrollView addSubview:imageView];
        
        if (i==4) {
            UIButton *useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            useBtn.frame = CGRectMake(50, SCREENHEIGHT*4.0/7.0, SCREENWIDTH-100, SCREENHEIGHT*3.0/7.0);
            [useBtn addTarget:self action:@selector(useBtnAction) forControlEvents:UIControlEventTouchUpInside];
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:useBtn];
        }
    }
    
    
    NSDictionary *dic = @{
                          @"user_id1":@[@{
                                           @"task_id1":@{
                                                   @"hasRec":@[],
                                                   @"noRec":@[]
                                                   }
                                           },
                                       @{
                                           @"task_id2":@{
                                                   @"hasRec":@[],
                                                   @"noRec":@[]
                                                   }
                                           }],
                          @"user_id2":@[@{
                                           @"task_id1":@{
                                                   @"hasRec":@[],
                                                   @"noRec":@[]
                                                   }
                                           },
                                       @{
                                           @"task_id2":@{
                                                   @"hasRec":@[],
                                                   @"noRec":@[]
                                                   }
                                           }],
                          };
}


-(void)useBtnAction{
    BBLoginViewController * loginController = [[BBLoginViewController alloc]init];
    UINavigationController *loginWithNavigation = [[UINavigationController alloc]initWithRootViewController:loginController];
    loginWithNavigation.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:loginWithNavigation animated:YES completion:nil];
}

@end
