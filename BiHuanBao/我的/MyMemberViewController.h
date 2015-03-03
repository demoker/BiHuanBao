//
//  ViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/8.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "WalletInfoView.h"
@interface MyMemberViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    JRNavgationBar * navBar;
    WalletInfoView * infoView;
}

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *my_quan;
@property (weak, nonatomic) IBOutlet UIView *my_wallet;
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) NSMutableArray * dataarray;
@property (weak, nonatomic) IBOutlet UIView *headview;
@property (weak, nonatomic) IBOutlet UIImageView *line;

@end
