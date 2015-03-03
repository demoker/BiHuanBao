//
//  BiAiTuanFinalViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductFinalHeadView.h"
#import "ProductEvaluateSectionCell.h"
#import "LoginController.h"
@interface BiAiTuanFinalViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,TableViewDelegate,LoginDelegate>
{
    BOOL ishas;
    NSTimer * mtimer;
    BOOL ad_already_create;//广告是否请求回来
    BOOL noti_already_create;//通知是否请求回来
    ProductEvaluateSectionCell * sectionCell;
    
    int more;
}

@property (retain, nonatomic) IBOutlet TableView *mtableview;

@property (retain, nonatomic) JRNavgationBar * navBar;
@property (retain, nonatomic) NSMutableArray * images_ad;
@property (retain, nonatomic) NSMutableArray * pics;

@property (weak, nonatomic) IBOutlet UIButton *yuyueBtn;
@property (retain, nonatomic) NSMutableArray * evaluates;
@property (retain, nonatomic) ProductFinalHeadView * headView;


@property (retain, nonatomic) NSString * auto_id;
@property (retain, nonatomic) NSString * content_name;
@property (retain, nonatomic) NSString * content_preprice;
@property (retain, nonatomic) NSString * sub_title;
@property (retain, nonatomic) NSString * content_score;
@property (retain, nonatomic) NSString * total_num;
@property (retain, nonatomic) NSString * site;
@property (retain, nonatomic) NSString * tel;
@property (retain, nonatomic) NSString * address;
@property (retain, nonatomic) NSString * content_desc;//购买须知
@property (retain, nonatomic) NSString * content_body;
@property (retain, nonatomic) NSString * content_Enumbers;//评价人数
@property (retain, nonatomic) NSString * corp_id;
@end
