//
//  GNWebViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/07.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNWebViewController.h"

@interface GNWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation GNWebViewController


- (instancetype)initWithURL:(NSString *)urlString{
    self = [super init];
    if (self) {
        self.urlString = urlString;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
   
    [self.view addSubview:_webView];
    
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

@end
