//
//  AppDelegate.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/26.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELViewDelegate.h"
#import "BMapKit.h"
#import "ELTabBar.h"
#import "RootViewController.h"
#import "ShoppingCartViewController.h"
#import "WalletViewController.h"
#import "MyMemberViewController.h"
#import "LoginController.h"
#import "CorpMemberViewController.h"

#define UMENG_APPKEY @"53e08b3bfd98c51cde006d02"
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate,LoginDelegate>
{
    CLLocationManager      *locationmanager;
    
    UINavigationController * nav1;
    UINavigationController * nav2;
    UINavigationController * nav3;
    UINavigationController * nav4;
    UINavigationController * nav5;
    UINavigationController * nav6;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ELViewDelegate * viewDelegate;
@property (strong, nonatomic) NSString * devices_token;
@property (strong, nonatomic) BMKMapManager *mapManager;
@property (retain, nonatomic) ELTabBar * tab;

- (void)setTabBarViewController:(int)index;

- (void)goLoginUser:(BOOL)islogin;

- (void)selectTabItem:(int)index;
@end

