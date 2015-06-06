//
//  GNLoginViewController.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/07.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "GNLoginViewController.h"
#import "GNApiMnager.h"

@interface GNLoginViewController ()
<UIWebViewDelegate>

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)UIButton *startButton;
@end

@implementation GNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView.image = [UIImage imageNamed:@"uber_login"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60)];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setFrame:CGRectMake(self.bottomView.frame.size.width - 100 - 10, (self.bottomView.frame.size.height - 44)/2, 100, 44)];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.loginButton];
    
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startButton setFrame:CGRectMake(10, (self.bottomView.frame.size.height - 44)/2, 100, 44)];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.startButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commonInit{
    
    
}


- (void)loginButtonTapped:(id)sender{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://"]]) {
        // Do something awesome - the app is installed! Launch App.
    }
    else {
        // No Uber app! Open Mobile Website.
        [self showWebView];
    }
}

- (void)showWebView{
 
    NSString *str = [NSString stringWithFormat:@"https://login.uber.com/oauth/authorize?response_type=code&client_id&%@",UBER_CLIENT_ID];

}

- (void)startButtonTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}






@end
