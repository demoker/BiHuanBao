//
//  IWantSongViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/7.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface IWantSongViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) NSString * auto_id;

@property (retain, nonatomic) NSString * corp_name;
@property (retain, nonatomic) NSString * sub_title;
@property (retain, nonatomic) NSString * giving;
@property (retain, nonatomic) NSString * total;
@property (retain, nonatomic) NSString * current;
@property (retain, nonatomic) NSString * all_yuyue;//总预约额

@property (retain, nonatomic) NSString * number_btc;//预约比特币的数目

@end
