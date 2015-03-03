//
//  IWantTuanViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/2.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface IWantTuanViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (retain, nonatomic) JRNavgationBar * navBar;
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) NSString * number;
@property (retain, nonatomic) NSString * total;
@property (retain, nonatomic) NSString *price;
@property (retain, nonatomic) NSString * account;//账户余额
@property (retain, nonatomic) NSString * auto_id;
@property (retain, nonatomic) ProductListItem * m_product;
@property (retain, nonatomic) NSString * content_user;
@property (retain, nonatomic) NSString * corp_id;//店铺id

@end
