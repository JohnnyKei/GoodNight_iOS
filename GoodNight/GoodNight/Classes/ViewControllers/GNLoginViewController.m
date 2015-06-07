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
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>
#import <gtm-oauth2/GTMOAuth2Authentication.h>
#import <gtm-oauth2/GTMOAuth2SignIn.h>


static NSString *const kKeychainItemName = @"Uber";


@interface GNLoginViewController ()

@property (nonatomic, strong)UIImageView *imageView;
//@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)UIButton *loginButton;
//@property (nonatomic, strong)UIButton *startButton;
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation GNLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.imageView.image = [UIImage imageNamed:@"uber_login"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    
//    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60)];
//    self.bottomView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.bottomView];
    
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
    
//    
//    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.startButton setFrame:CGRectMake(10, (self.bottomView.frame.size.height - 44)/2, 100, 44)];
//    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
//    [self.startButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.startButton addTarget:self action:@selector(startButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bottomView addSubview:self.startButton];
    // Do any additional setup after loading the view.
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
 
    NSString *str = [NSString stringWithFormat:@"https://login.uber.com/oauth/authorize?response_type=code&client_id=%@",UBER_CLIENT_ID];
    
   GNWebViewController *loginVC = [[GNWebViewController alloc]initWithURL:str];
    [self.navigationController pushViewController:loginVC animated:YES];
    
    
//    GTMOAuth2Authentication *auth = [GTMOAuth2Authentication authenticationWithServiceProvider:@"MyService" tokenURL:nil redirectURI:@"https://goodnight.herokuapp.com/" clientID:UBER_CLIENT_ID clientSecret:nil];
//    // Specify the appropriate scope string, if any, according to the service's API documentation
//    auth.scope = @"";
//    
//    NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://login.uber.com/oauth/authorize"]];
//    
//    // Display the authentication view
//    GTMOAuth2ViewControllerTouch *viewController = [[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:auth
//              authorizationURL:authURL
//              keychainItemName:kKeychainItemName
//                      delegate:self
//              finishedSelector:@selector(viewController:finishedWithAuth:error:)] ;
//    
//    // Now push our sign-in view
////    [[self navigationController] pushViewController:viewController animated:YES];
//    [self.navigationController pushViewController:viewController animated:YES];
//    viewController.rightBarButtonItem = nil;
}

- (void)startButtonTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)auth
                 error:(NSError *)error {
    if (error != nil) {
        // Sign-in failed
        DLog(@"error:%@",error);
    } else {
        // Sign-in succeeded
        DLog(@"auth:%@",auth);
    }
}





@end
