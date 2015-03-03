//
//  ShoppingCartViewController.h
//  BuyBuyring
//
//  Created by 易龙天 on 13-12-3.
//  Copyright (c) 2013年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"
#import "BBRShopCarEditView.h"
@interface ShoppingCartViewController : BaseViewController<JRNavDelegate,UITableViewDataSource,UITableViewDelegate,LoginDelegate,UITextFieldDelegate>{
    JRNavgationBar * navTitleView;
    UILabel * ShoppLabel;
    BOOL isedit;
    float money;
    UIView * back_control;
}
@property (nonatomic,retain) IBOutlet UITableView * ShoppTableView;
@property (nonatomic,retain) IBOutlet UILabel * TotelmoneyLabel;
@property (nonatomic,retain) IBOutlet UILabel * numberLabel;
@property (nonatomic,retain) IBOutlet UIButton * SettlementBtn;
@property (nonatomic,retain) IBOutlet UIView * SettlementView;

@property (nonatomic,retain) NSMutableArray * dataArr;
@property (nonatomic,retain) NSIndexPath *selectedIndexPath;//这个是用于删除
@property (nonatomic,retain) NSIndexPath * editSelectIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *continueShop;

@property (retain, nonatomic) NSMutableString * str_auto_id;
@property (retain, nonatomic) NSMutableString * str_num;

@property (retain, nonatomic) NSString * totalMoney;
@property (retain, nonatomic) NSString * totalNum;

@property (retain, nonatomic) NSString * defaultNumber;//用户点击textfield输入前的值


@end
