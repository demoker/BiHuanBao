//
//  BaoPaymentController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/7.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface BaoPaymentController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    JRNavgationBar * navTitleView;
    CGFloat keyboardheight;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) NSString * str_num;
@property (retain, nonatomic) NSString * str_auto_id;

@property (retain, nonatomic) NSString * totalMoney;
@property (retain, nonatomic) NSString * yu_e;
@property (retain, nonatomic) NSString * contact;
@property (retain, nonatomic) NSString * tel;
@property (retain, nonatomic) NSString * address;
@property (retain, nonatomic) NSString * username;
@end
