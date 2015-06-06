//
//  AppDelegate.m
//  GoodNight
//
//  Created by SatoKei on 2015/06/06.
//  Copyright (c) 2015年 KeiSato. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GNMenuViewController.h"
#import "GNSegmentViewController.h"
#import "GNHotelListViewController.h"
#import "GNMapViewController.h"
#import "GNMenuViewController.h"
#import "GNProfileViewController.h"
#import "GNSideMenuViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GMSServices provideAPIKey:GOOGLE_MAPS_KEY];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    GNHotelListViewController *hotelVC = [[GNHotelListViewController alloc]init];
    GNMapViewController *mapVC = [[GNMapViewController alloc]init];
    GNSegmentViewController *segmentVC = [[GNSegmentViewController alloc]initWithViewControllers:@[hotelVC, mapVC] titles:@[@"HOTEL",@"MAP"] barHeight:120];
    segmentVC.barBackgroundColor = RGBA(19, 18, 36, 1);
    segmentVC.titleColor = [UIColor whiteColor];
    segmentVC.selectedTitleColor = [UIColor whiteColor];
    segmentVC.indicatiorColor = [UIColor whiteColor];
    segmentVC.automaticallyAdjustsScrollViewInsets = NO;
    
   
    GNProfileViewController *profileVC = [[GNProfileViewController alloc]init];
    
    GNMenuViewController *menuVC = [[GNMenuViewController alloc]initWithViewControllers:@[segmentVC, profileVC] titles:@[@"Home",@"Profile"]];
    
//    GNLoginViewController *loginVC = [[GNLoginViewController alloc]init];

    GNSideMenuViewController *sideMenuVC = [[GNSideMenuViewController alloc]initWithMenuViewController:menuVC contentViewController:segmentVC];
    
//    sideMenuVC.menuFrame = CGRectMake(0, 0, 200, self.window.bounds.size.height);
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sideMenuVC];
    [nav setNavigationBarHidden:YES];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
