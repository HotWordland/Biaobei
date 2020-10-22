//
//  BBAggreProtocolViewController.m
//  Biaobei
//
//  Created by 胡志军 on 2019/10/20.
//  Copyright © 2019年 文亮. All rights reserved.
//

#import "BBAggreProtocolViewController.h"

@interface BBAggreProtocolViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView * webView;
@end
@implementation BBAggreProtocolViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"数据工厂个人信息采集授权书";
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:AuthorizationProtocol]];
    
    //创建 webview 对象
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.delegate = self;
    [self.view addSubview: self.webView];
    
    [self.webView loadRequest:request];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset = 0;
    }];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    self.webView = nil;
    self.webView.delegate= self;
    
}
@end
