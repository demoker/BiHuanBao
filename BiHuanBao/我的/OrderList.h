//
//  OrderList.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/22.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderList : BaseViewController<UITableViewDataSource,UITableViewDelegate,TableViewDelegate>
{
    int more;
}
@property (weak, nonatomic) IBOutlet TableView *mtableview;
@property (retain, nonatomic) NSMutableArray * dataarray;
@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) NSString * task;
@property (retain, nonatomic) NSString * app_com;
- (void)refresh;
@end
