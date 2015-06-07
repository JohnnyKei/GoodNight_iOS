//
//  GNLoginViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/07.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNLoginViewController.h"
#import "GNApiMnager.h"
#import "GNWebViewController.h"


@interface GNLoginViewController ()

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation GNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView.image = [UIImage imageNamed:@"uber_login"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];

    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 200)/2, self.view.center.y - 120, 200, 40)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"GoodNight";
    _titleLabel.font = [UIFont boldSystemFontOfSize:32];
    [self.view addSubview:_titleLabel];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setFrame:CGRectMake((self.view.frame.size.width - 200)/2, self.view.center.y + 120, 200, 44)];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:RGBA(30, 186, 214, 1)];
    [self.loginButton.layer setShadowRadius:2];
    [self.loginButton.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.loginButton.bounds].CGPath];
    [self.loginButton.layer setShadowOpacity:0.7];
    [self.loginButton.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)loginButtonTapped:(id)sender{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]) {
        // Do something awesome - the app is installed! Launch App.
//        NSString *url = [NSString stringWithFormat:@"uber://?action=setPickup&pickup=my_location?"];
//        [UIApplication sharedApplication]openURL:[NSURL URLWithString:<#(NSString *)#>]
    }
    else {
        // No Uber app! Open Mobile Website.
    }
    [self showWebView];

}

- (void)showWebView{
 
    NSString *str = [NSString stringWithFormat:@"https://login.uber.com/oauth/authorize?response_type=code&client_id=%@&scope=request",UBER_CLIENT_ID];
    
   GNWebViewController *loginVC = [[GNWebViewController alloc]initWithURL:str];
    [self.navigationController pushViewController:loginVC animated:YES];
    
 
}

- (void)startButtonTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}








@end
