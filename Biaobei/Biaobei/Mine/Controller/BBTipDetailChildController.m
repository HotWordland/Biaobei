//
//  BBTipDetailChildController.m
//  WLBaseProject
//
//  Created by 文亮 on 2019/9/4.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BBTipDetailChildController.h"
#import "BBHomeListCellModel.h"
#import "BBHomeListBeanModel.h"
#import "BBHomeProjectDetailListViewController.h"
#import "BBTipDetailListViewController.h"

@implementation BBTipDetailChildController
{
    int loadDataCount;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self prepareData];
    [self getData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.initList) {
        self.initList = YES;
        [self refresh];
    }
}

-(void)getData{
    loadDataCount++;
    NSString *pageNum = [NSString stringWithFormat:@"%d",loadDataCount];
  
    NSString *status = @"0";
    if (_status == NoRefer) {//未录制  或  未提交
        status = @"0";
    }else if (_status==NoAccess){//未通过
        status = @"3";
    }else if (_status==Acess){//通过
        status = @"1";
    }else if (_status==Checking){//质检中
        status = @"2";
    }
    NSDictionary *params = @{
                             @"pageNum":pageNum,
                             @"pageSize":@"10"
                             };
    [[BBRequestManager sharedInstance] getUserTaskListWithStatus:status params:params success:^(id  _Nonnull responseObject, JSONModel * _Nonnull model) {
        NSLog(@"1");
    } failure:^(NSString * _Nonnull error) {
        NSLog(@"2");
    }];
}

-(void)prepareData {
    BBHomeListCellModel * firstCellModel = [[BBHomeListCellModel alloc]initWithData:nil];
    BBHomeListBeanModel * firstBeanModel = (BBHomeListBeanModel *)firstCellModel.beanModel;
    firstBeanModel.title = [NSString stringWithFormat:@"%@",@"粤语女声1000句采集任务"];
    firstBeanModel.summary = @"总条目45  未录制23";
    firstBeanModel.tipString = [self getAttributeString:@"距离2019-03-27任务结束还有24天" withTip:@"24" withColor:[UIColor redColor]];
    [self.dataListArray addObject:firstCellModel];

    BBHomeListCellModel * sectiondCellModel = [[BBHomeListCellModel alloc]initWithData:nil];
    BBHomeListBeanModel * sectiondBeanModel = (BBHomeListBeanModel *)sectiondCellModel.beanModel;
    sectiondBeanModel.title = [NSString stringWithFormat:@"%@",@"粤语女声1000句采集任务"];
    sectiondBeanModel.summary = @"总条目45  未录制23";
    sectiondBeanModel.tipString = [self getAttributeString:@"该任务已结束" withTip:@"该任务已结束" withColor:[UIColor redColor]];
    [self.dataListArray addObject:sectiondCellModel];

    BBHomeListCellModel * thirdCellModel = [[BBHomeListCellModel alloc]initWithData:nil];
    BBHomeListBeanModel * thirdBeanModel = (BBHomeListBeanModel *)thirdCellModel.beanModel;
    thirdBeanModel.title = [NSString stringWithFormat:@"%@",@"泰语男声80句多人采集任务"];
    thirdBeanModel.summary = @"多人采集  不同文本";
    thirdBeanModel.tipString = [self getAttributeString:@"你无权访问该任务" withTip:@"你无权访问该任务" withColor:[UIColor redColor]];
    [self.dataListArray addObject:thirdCellModel];

    BBHomeListCellModel * fourthCellModel = [[BBHomeListCellModel alloc]initWithData:nil];
    BBHomeListBeanModel * fourthBeanModel = (BBHomeListBeanModel *)fourthCellModel.beanModel;
    fourthBeanModel.title = [NSString stringWithFormat:@"%@",@"藏语女声160句采集任务"];
    fourthBeanModel.summary = @"多人采集  不同文本";
    fourthBeanModel.tipString = [self getAttributeString:@"距离2019-03-27任务结束还有30天" withTip:@"30" withColor:[UIColor redColor]];
    [self.dataListArray addObject:fourthCellModel];
}

-(NSAttributedString *)getAttributeString: (NSString *)string  withTip:(NSString *)tip withColor:(UIColor *)color {
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:string];
    [attribute addAttributes:@{NSForegroundColorAttributeName: color} range: [string rangeOfString:tip]];
    return attribute;
}

-(BOOL)canLoadMore {
    return false;
}

-(void)didSelectItemAtSection:(NSInteger)section Indext:(NSInteger)index withModel:(BaseCellModel *)model {
    if (self.status == NoRefer || self.status == Checking) {
        BBTipDetailListViewController * controller = [[BBTipDetailListViewController alloc]init];
        [controller tag:self.status];
        [self.navigationController pushViewController:controller animated:YES];
    }

}


@end
