//
//  TransactionRecordsViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/2.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface TransactionRecordsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,TableViewDelegate>
{
    int more;
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UILabel *sum;
@property (weak, nonatomic) IBOutlet UILabel *yu_e;
@property (weak, nonatomic) IBOutlet TableView *mtableview;
@property (retain, nonatomic) NSArray * widths;
@property (retain, nonatomic) NSArray * orgions;
@property (retain, nonatomic) NSArray * tags;
@property (retain, nonatomic) NSString * app_com;
@property (retain, nonatomic) NSMutableArray * dataarray;
@end
