//
//  RootViewController.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-6.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "B2CRootHeaderView.h"
#import "LoginController.h"
#import "LocationManager.h"
#import "JCTopic.h"
#import "TableView.h"

@interface RootViewController :BaseViewController <JRNavDelegate,UITextFieldDelegate ,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,JCTopicDelegate,LoginDelegate,LocationManagerDelegate,TableViewDelegate>
{
    B2CRootHeaderView * rootHeadView;
//    SearchViewController * searchViewController;
    BOOL ishas;
    NSTimer * mtimer;
    BOOL ad_already_create;//广告是否请求回来
    BOOL noti_already_create;//通知是否请求回来
    LocationManager * locationmanager;
    NSArray * icons;
    
    NSArray * colors;
    
    int more;
}
@property (weak, nonatomic) IBOutlet TableView *mtableview;
@property (retain, nonatomic) JRNavgationBar * navBar;
@property (retain, nonatomic) NSMutableArray * images_ad;
@property (retain, nonatomic) JCTopic * Topic;
@property (retain, nonatomic) UIPageControl * mpagecontrol;
@property (retain, nonatomic) NSMutableArray * pics;

@property (retain, nonatomic) NSMutableArray * productArray;
@property (retain, nonatomic) NSMutableArray * citys;//城市数组

@property (retain, nonatomic) NSString * default_city;
@property (retain, nonatomic) NSString * default_city_id;
- (void)setTitleframe;
@end
