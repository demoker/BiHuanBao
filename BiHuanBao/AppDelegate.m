//
//  AppDelegate.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/26.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "BBRGuideViewController.h"
#import "Harpy.h"
#import <ShareSDK/ShareSDK.h>

#import "WXApi.h"
#import "WeiboApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>






static BOOL bool_initNavs = YES;


//#import "UMSocial.h"
@implementation AppDelegate
@synthesize tab;


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [self clearMessage];
    
    application.applicationIconBadgeNumber = 0;
}

- (void)clearMessage
{
    NSString * strUrl = [NSString stringWithFormat:@"%@&method=save&app_com=com_mqapp&task=iosClear&devices_token=%@",HTTP,self.devices_token];
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@">" withString:@""];
    [[ELHttpRequestOperation sharedClient] GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DLog(@"%@",deviceToken);
    self.devices_token = [NSString stringWithFormat:@"%@",deviceToken];
    [self requestSever];
}
- (void)requestSever
{
    NSString* devices_name = [[UIDevice currentDevice] name];
    NSString* devices_version = [[UIDevice currentDevice] systemVersion];
    NSString* devices_type = [[UIDevice currentDevice] model];
    NSString* mode = @"Development";
    NSString * push_server = [NSString stringWithFormat:@"%@/api/app/apns.php?action=registerDevices",HTTP];
    NSString *strUrl = [NSString stringWithFormat:@"%@&devices_token=%@&devices_name=%@&devices_version=%@&devices_type=%@&mode=%@",push_server,self.devices_token,[devices_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],devices_version,devices_type,mode];
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"<" withString:@""];
    strUrl = [strUrl stringByReplacingOccurrencesOfString:@">" withString:@""];
    [[ELHttpRequestOperation sharedClient] GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSString *error_str = [NSString stringWithFormat: @"%@", error];
    NSLog(@"Failed to get token, error:%@", error_str);
}



#pragma mark - setTabBar

- (void)initNavs
{
    RootViewController * root = [[RootViewController alloc]initWithNibName:@"RootViewController" bundle:nil];
    root.titleName = @"主页";
    nav1 = [[UINavigationController alloc]initWithRootViewController:root];
    nav1.navigationBar.hidden = YES;
    
    
    ShoppingCartViewController * shopcar = [[ShoppingCartViewController alloc]initWithNibName:@"ShoppingCartViewController" bundle:nil];
    shopcar.is_menu = YES;
    shopcar.titleName = @"购物车";
    nav2 = [[UINavigationController alloc]initWithRootViewController:shopcar];
    nav2.navigationBar.hidden = YES;
    
    WalletViewController * wallet = [[WalletViewController alloc]initWithNibName:@"WalletViewController" bundle:nil];
    wallet.titleName = @"钱包";
    wallet.is_menu = YES;
    nav3 = [[UINavigationController alloc]initWithRootViewController:wallet];
    nav3.navigationBar.hidden = YES;
    
    MyMemberViewController * member =[[MyMemberViewController alloc]initWithNibName:@"MyMemberViewController" bundle:nil];
    member.titleName = @"个人中心";
    member.is_menu = YES;
    nav4 = [[UINavigationController alloc]initWithRootViewController:member];
    nav4.navigationBar.hidden = YES;
    
    CorpMemberViewController * corpMem = [[CorpMemberViewController alloc]initWithNibName:@"CorpMemberViewController" bundle:nil];
    corpMem.titleName = @"个人中心";
    nav5 = [[UINavigationController alloc]initWithRootViewController:corpMem];
    nav5.navigationBar.hidden = YES;
    
    LoginController * login = [[LoginController alloc]init];
    login.islogin = YES;
    nav6 = [[UINavigationController alloc]initWithRootViewController:login];
    nav6.navigationBar.hidden = YES;
}

- (void)setTabBarViewController:(int)index
{
    if(bool_initNavs)
    {
        [self initNavs];
        bool_initNavs = NO;
    }
    else
    {
        
    }
    
    NSMutableArray * vcs = [[NSMutableArray alloc]initWithObjects:nav1,nav2,nav3,nav4, nil];
    
    NSMutableArray * vcs2 = [[NSMutableArray alloc]initWithObjects:nav1,nav2,nav3,nav5, nil];
    tab = [[ELTabBar alloc]initWithNibName:@"ELTabBar" bundle:nil];
    
    
    NSArray * titles = [[NSArray alloc]initWithObjects:@"首页",@"购物车",@"钱包",@"我的", nil];
    NSArray * nomal_images = [[NSArray alloc]initWithObjects:@"s1",@"s2",@"s3",@"s4", nil];
    NSArray * select_images = [[NSArray alloc]initWithObjects:@"s10",@"s20",@"s30",@"s40", nil];
    if([[[UserLoginInfoManager loginmanager] isCorper] integerValue] == 2)
    {
        [tab setTabWithArray:vcs2 NormalImageArray:nomal_images SelectedImageArray:select_images NomalTitles:titles SelectedTitles:titles nomalTitleColor:UIColorFromRGB(0x535353) selectedTitleColor:UIColorFromRGB(0xff5000) nomalBackimage:nil selectedBackimage:nil];
    }
    else
    {
        NSMutableArray * arr = [[NSMutableArray alloc]initWithArray:nav1.viewControllers];
        if([arr count]!=1)
        {
            for(int i = 1;i<[arr count];i++)
            {
                [arr removeObjectAtIndex:i];
            }
        }
        
        [tab setTabWithArray:vcs NormalImageArray:nomal_images SelectedImageArray:select_images NomalTitles:titles SelectedTitles:titles nomalTitleColor:UIColorFromRGB(0x535353) selectedTitleColor:UIColorFromRGB(0xff5000) nomalBackimage:nil selectedBackimage:nil];
    }
    
    [self.window setRootViewController:tab];
    
    [tab selectIndex:index];

}

#pragma mark - 登录

- (void)goLoginUser:(BOOL)islogin
{
    LoginController * login = [[LoginController alloc]initWithNibName:@"LoginController" bundle:nil];
    login.islogin = islogin;
    login.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
    nav.navigationBar.hidden = YES;
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

- (void)loginfinished
{
    [self setTabBarViewController:3];
}
#pragma mark - ---------

- (id)init
{
    self = [super init];
    if(self)
    {
        _viewDelegate = [[ELViewDelegate alloc] init];
    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (IOS7) { // 判断是否是IOS7
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        
    }
    
    
    [ShareSDK registerApp:@"235058e2a800"];
    
    [self initializePlat];
    
    [Harpy home_checkVersion];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginState"] boolValue])
    {
        [[UserLoginInfoManager loginmanager] setState:YES];
        [[UserLoginInfoManager loginmanager] setIsCorper:[[NSUserDefaults standardUserDefaults] objectForKey:@"isCorper"]];
        [[UserLoginInfoManager loginmanager] setUser:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
        [[UserLoginInfoManager loginmanager] setPwd:[FileMangerObject md5:OBJC([[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"])]];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoginState"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"user"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"pwd"];
    }
    
    //增加标识，用于判断是否是第一次启动应用...
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//    }
    
    NSLog(@"程序是否是第一次应用----%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        //程序第一次启动，进入引导页面
        BBRGuideViewController *appStartController = [[BBRGuideViewController alloc] init];
        self.window.rootViewController = appStartController;
    }else {
        //程序不是第一次启动，进入主页面
        [self setTabBarViewController:0];
    }
    
//    _mapManager = [[BMKMapManager alloc]init];
//    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
//    BOOL ret = [_mapManager start:@"FDtz7b2pqQpTaov93e9g59d0"  generalDelegate:nil];
//    
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }
    
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    }  else {
//        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
//    }
    
    
    //    [UIApplication sharedApplication].idleTimerDisabled = TRUE;
    
    
//    if(IOS8)
//    {
//        locationmanager = [[CLLocationManager alloc] init];
//        [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
//        [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
//        locationmanager.delegate = self;
//    }
    
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    //
    //    {
    //
    //        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    //
    //    }
    //
    //
    //    UILocalNotification * notification = [[UILocalNotification alloc] init];
    //
    //    //设置10秒之后
    //
    //    //    NSDate * Date = [NSDate dateWithTimeIntervalSinceNow:5];
    //    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    //    NSInteger interval = [zone secondsFromGMTForDate: Date];
    //    //    NSDate *pushDate = [Date  dateByAddingTimeInterval: interval];
    //    NSDate * pushDate = [[NSDate new] dateByAddingTimeInterval:5];
    //    DLog(@"%@",pushDate);
    //    if (notification != nil) {
    //        // 设置推送时间
    //        notification.fireDate = pushDate;
    //        // 设置时区
    //        notification.timeZone = [NSTimeZone systemTimeZone];
    //        // 设置重复间隔
    //        notification.repeatInterval = kCFCalendarUnitDay;
    //        // 推送声音
    //        notification.soundName = UILocalNotificationDefaultSoundName;
    //        // 推送内容
    //        notification.alertBody = @"推送内容";
    //        //显示在icon上的红色圈中的数子
    //        notification.applicationIconBadgeNumber = 1;
    //        //设置userinfo 方便在之后需要撤销的时候使用
    //        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
    //        notification.userInfo = info;
    //        //添加推送到UIApplication
    //        UIApplication *app = [UIApplication sharedApplication];
    //        [app scheduleLocalNotification:notification];
    //    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if(application.applicationIconBadgeNumber!=0)
    {
        RootViewController * root = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
        [self clearMessage];
        
        application.applicationIconBadgeNumber = 0;
    }
    [self clearMessage];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}
#pragma mark -----

- (void)initializePlat
{
    //------------------------------------
    /** 连接新浪微博开放平台应用以使用相关功能，此应用需要引用SinaWeiboConnection.framework
     http://open.weibo.com上注册新浪微博开放平台应用，并将相关信息填写到以下字段
     **/
    [ShareSDK connectSinaWeiboWithAppKey:@"306649366"
                               appSecret:@"81f5a6b6f1173d7d58b19f58049c610b"
                             redirectUri:@"http://dj.7-hotel.com/"];
    
    /**
     连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
     http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入libWeiboSDK.a，并引入WBApi.h，将WBApi类型传入接口
     **/
    [ShareSDK connectTencentWeiboWithAppKey:@"1101736043"
                                  appSecret:@"TNNrnim5dEF4u1SH"
                                redirectUri:@"http://dj.7-hotel.com/download/"
                                   wbApiCls:[WeiboApi class]];
    
    //连接短信分享
    [ShareSDK connectSMS];
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1101736043"
                           appSecret:@"TNNrnim5dEF4u1SH"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    [ShareSDK connectWeChatWithAppId:@"wx5354085a0152c131" wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1101736043"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    
    
    //连接邮件
    [ShareSDK connectMail];
    
    //连接拷贝
    [ShareSDK connectCopy];
}


- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)changeTabarArray
{
    
}

- (void)selectTabItem:(int)index
{
    [tab selectIndex:index];
}

@end
