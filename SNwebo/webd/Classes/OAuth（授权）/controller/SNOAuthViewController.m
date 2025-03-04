//
//  SNOAuthViewController.m
//  webd
//
//  Created by 普伴 on 15/8/18.
//  Copyright (c) 2015年 Puban. All rights reserved.
//

#import "SNOAuthViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "SNAccount.h"
#import "SNAccountTool.h"
#import "SNControllerTool.h"
@interface SNOAuthViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) UIWebView *webView;
@end

@implementation SNOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // 1.创建一个UIWebView
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    self.webView = webView;
 
    
    // 2.加载登陆页面
    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",SNAppKey,SNRedirectURI];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    // 3.设置代理
    webView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  UIWebView开始加载资源时调用
 */
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在拼命加载..."];
}

/**
 *  UIWebView加载完闭
 */
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

/**
 *  UIWebView加载失败
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

/**
 *  请求访问
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.获取请求地址
    NSString *url = request.URL.absoluteString;
    
    
    
    // 2.判断URl是否为回调地址
    NSString *str = [NSString stringWithFormat:@"%@?code=",SNRedirectURI];
   
    NSRange range = [url rangeOfString:str];
    
    
    if (range.location != NSNotFound) {
        
        // 截取授权成功后的请求标记
        unsigned long from = range.location +range.length;
        NSString *code = [url substringFromIndex:from];
        
        // 根据code获取一个accessToken
        [self accessTokenWithCode:code];
        
        // 禁止加载页面
        return NO;
    }
    return YES;

}

- (void)accessTokenWithCode:(NSString *)code
{

    // 1.封装请求参数
    SNAccessTokenParam *param = [[SNAccessTokenParam alloc] init];
    param.client_id = SNAppKey;
    param.client_secret = SNAppSecret;
    param.redirect_uri = SNRedirectURI;
    param.grant_type = @"authorization_code";
    param.code = code;
    
    // 2获取accessToken
    [SNAccountTool accessTokenWithParam:param success:^(SNAccount *account) {
        
        // 隐藏HUD
        [MBProgressHUD hideHUD];
        
        // 存储账号模型
        [SNAccountTool save:account];
        
        // 切换控制器
        [SNControllerTool chooseRootViewController];
    } failure:^(NSError *error) {
        
        
        // 隐藏HUD
        [MBProgressHUD hideHUD];
        
        SNLog(@"请求发送时报------%@",error);
    }];
}



@end
