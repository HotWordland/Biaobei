//
//  BaseWebViewController.m
//  Biaobei
//
//  Created by 黎仕仪 on 2019/9/23.
//  Copyright © 2019 文亮. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>

@interface BaseWebViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    WKWebView *myWebView;
    UILabel *naviTitleLabel;
    NSString *webDesc;
}

@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;

    self.title = _webTitle;
    [self createSubViews];
}

-(void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
}

-(void)setWebTitle:(NSString *)webTitle{
    _webTitle = webTitle;
    self.title = webTitle;
}

-(void)createSubViews{
    myWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-StatusAndNaviHeight)];
    myWebView.navigationDelegate = self;
    myWebView.UIDelegate = self;
    [myWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];

    NSURL *url = [NSURL URLWithString:_urlStr];
    if (url) {
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [myWebView loadRequest:request];
    } else {
        [myWebView loadHTMLString:_urlStr baseURL:nil];
    }
  
    [self.view addSubview:myWebView];
    
}

- (BOOL)isValidUrl:(NSString *)urlStr
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:urlStr];
}

//返回
-(void)backButtonClick{
    if (_isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败%@", error.userInfo);
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{

}

//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)){
//    [webView reload];
//}

//WkWebView的 回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
}
- (void)dealloc {
    [myWebView removeObserver:self forKeyPath:@"title"];
    myWebView  = nil;
    myWebView.UIDelegate = nil;
    myWebView.navigationDelegate = nil;
}

@end
