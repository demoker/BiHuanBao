//
//  BiHuanBaoFinalViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductFinalHeadView.h"
#import "ProductEvaluateSectionCell.h"
@interface BiHuanBaoFinalViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TableViewDelegate>
{
    BOOL ishas;
    NSTimer * mtimer;
    BOOL ad_already_create;//广告是否请求回来
    BOOL noti_already_create;//通知是否请求回来
    ProductEvaluateSectionCell * sectionCell;
    
    int more;
}

@property (weak, nonatomic) IBOutlet TableView *mtableview;

@property (weak, nonatomic) IBOutlet UIButton *yuyueBtn;
@property (retain, nonatomic) JRNavgationBar * navBar;
@property (retain, nonatomic) NSMutableArray * images_ad;
@property (retain, nonatomic) NSMutableArray * pics;

@property (retain, nonatomic) NSMutableArray * evaluates;
@property (retain, nonatomic) ProductFinalHeadView * headView;
@property (retain, nonatomic) NSString * number;//数量
@property (retain, nonatomic) NSString * defaultNumber;

@property (retain, nonatomic) NSString * auto_id;
@property (retain, nonatomic) NSString * corp_id;
@property (retain, nonatomic) NSString * content_img;
@property (retain, nonatomic) NSString * content_name;

@property (retain, nonatomic) NSString * corp_name;
@property (retain, nonatomic) NSString * content_price;
@property (retain, nonatomic) NSString * rmb;
@property (retain, nonatomic) NSString * region;
@property (retain, nonatomic) NSString * xiaoliang;
@property (retain, nonatomic) NSString * total_xiaoliang;
@property (retain, nonatomic) NSString * kucun;
@property (retain, nonatomic) NSString * star;
@property (retain, nonatomic) NSString * type_str;

@property (retain, nonatomic) NSString * content_desc;
@property (retain, nonatomic) NSString * content_body;

@end
