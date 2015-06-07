//
//  GNWebViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/07.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNWebViewController.h"
#import "GNApiMnager.h"


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



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = RGBA(19, 18, 36, 1);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DLog(@"Error:%@ webView:%@",error,webView.request.URL);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    DLog(@"webView:%@",webView.request.URL);
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
     DLog(@"webView:%@",webView.request.URL);
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSDictionary *queryParams = [self dictionaryFromQueryString:request.URL.query];
    DLog(@"%@",queryParams);
    DLog(@"web %@",webView.request.URL);
    if (queryParams) {
        for (NSString *key in queryParams) {
            if ([key isEqualToString:@"code"]) {
                [webView stopLoading];
                NSString *authCode = [queryParams objectForKey:@"code"];
//                DLog(@"authCode:%@",authCode);
//                NSString *url = [NSString stringWithFormat:@"https://login.uber.com/oauth/token?client_secret=%@&client_id=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",UBER_SECRET_KEY,UBER_CLIENT_ID,UBER_REDIRECT_URL,authCode];
//                [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
                
                
                
                
                
                
                
                
            [[GNApiMnager sharedManager]postRequest:@"https://login.uber.com/oauth/token"
            params:@{@"client_secret":UBER_SECRET_KEY,
                     @"client_id":UBER_CLIENT_ID,
                     @"grant_type":@"authorization_code",
                     @"redirect_uri":UBER_REDIRECT_URL,
                     @"code":authCode,
                     }
            success:^(id responseObject) {
                DLog(@"res:%@",responseObject);
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:[responseObject objectForKey:@"access_token"] forKey:UBER_ACCESS_TOKEN];
                [ud setObject:[responseObject objectForKey:@"refresh_token"] forKey:UBER_ACCESS_TOKEN];
                [ud synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            failure:^(NSError *error) {
                DLog(@"error:%@",error);
            }];
                
                return YES
                ;
                
                break;
            }
        }
    }
    
   

    
    return YES;
}




- (NSDictionary*)dictionaryFromQueryString:(NSString *)query
{
    // クエリ文字列が設定されている場合だけ、解析処理をします。
    if (query)
    {
        // 解析しながら、名前と値をここに蓄えて行きます。
        NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
        
        // クエリ文字列を "&" で分割して、ひとつひとつの "名前=値" の組に分解します。
        NSArray* parameters = [query componentsSeparatedByString:@"&"];
        
        for (NSString* parameter in parameters)
        {
            // "&" で区切られた文字列が、空文字ではないものを解析します。
            if (parameter.length > 0)
            {
                // 名前と値を分解します。
                NSArray* elements = [parameter componentsSeparatedByString:@"="];
                
                // 名前は UTF8 でエンコードされているものとしてデコードします。
                id key = [elements[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                // 値があればそれを UTF8 でデコードして取得します。名前だけで値の指定が無い場合は、ここでは値を @YES とみなします。
                id value = (elements.count == 1 ? @YES : [elements[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                
                // 取得した名前と値を保存します。重複は考慮していません。
                [result setObject:value forKey:key];
            }
        }
        
        // 取得した値と名前の組を、読み取り専用のインスタンスで返します。
        return [result copy];
    }
    else
    {
        // クエリ文字列が nil だった場合は、結果も nil を返します。
        return nil;
    }
}

@end
