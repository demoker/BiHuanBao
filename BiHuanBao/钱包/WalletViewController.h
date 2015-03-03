//
//  WalletViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/7.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "WalletInfoView.h"
@interface WalletViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,TableViewDelegate>
{
    JRNavgationBar * navBar;
    WalletInfoView * infoView;
}
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *banner;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UIButton *goMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *comeMoneyBtn;
@property (weak, nonatomic) IBOutlet TableView *mtableview;

@end
