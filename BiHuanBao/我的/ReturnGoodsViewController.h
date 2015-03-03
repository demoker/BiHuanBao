//
//  ReturnGoodsViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/27.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderItem.h"
@interface ReturnGoodsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) OrderItem * mitem;

@property (weak, nonatomic) IBOutlet UIButton *sure_receipt;
@end
