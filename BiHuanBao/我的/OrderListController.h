//
//  OrderListController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/11.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderList.h"
#import "ReturnGoodsList.h"
@interface OrderListController : BaseViewController
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (weak, nonatomic) IBOutlet UIButton *doing_order_btn;
@property (weak, nonatomic) IBOutlet UIButton *did_order_btn;
@property (weak, nonatomic) IBOutlet UIButton *return_order_btn;
@property (retain, nonatomic) OrderList * un_list;
@property (retain, nonatomic) OrderList * old_list;
@property (retain, nonatomic) ReturnGoodsList * return_list;
@property (weak, nonatomic) IBOutlet UIView *operationview;
@property (retain, nonatomic) NSString * type;
@property (retain, nonatomic) NSString * app_com;

@end
