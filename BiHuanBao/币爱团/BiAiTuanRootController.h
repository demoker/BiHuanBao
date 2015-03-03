//
//  BiAiTuanRootController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "TableView.h"
#import "B2CRootHeaderView.h"
#import "JCTopic.h"
@interface BiAiTuanRootController : BaseViewController<UITableViewDataSource,UITableViewDelegate,TableViewDelegate,JCTopicDelegate,UIScrollViewDelegate>
{
    B2CRootHeaderView * rootHeadView;
    //    SearchViewController * searchViewController;
    BOOL ishas;
    NSTimer * mtimer;
    BOOL ad_already_create;//广告是否请求回来
    BOOL noti_already_create;//通知是否请求回来
    int more;
}

@property (weak, nonatomic) IBOutlet TableView *mtableview;

@property (retain, nonatomic) JRNavgationBar * navBar;
@property (retain, nonatomic) NSMutableArray * images_ad;
@property (retain, nonatomic) JCTopic * Topic;
@property (retain, nonatomic) UIPageControl * mpagecontrol;
@property (retain, nonatomic) NSMutableArray * pics;

@property (retain, nonatomic) NSMutableArray * productArray;
@property (retain, nonatomic) NSMutableArray * classes;
@property (retain, nonatomic) NSString * default_code;//分类字段（显示）
@property (retain, nonatomic) NSString * default_code_id;//ID号
@end
