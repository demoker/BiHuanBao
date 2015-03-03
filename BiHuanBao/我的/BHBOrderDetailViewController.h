//
//  BHBOrderDetailViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderItem.h"
@interface BHBOrderDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) OrderItem * mitem;
@property (weak, nonatomic) IBOutlet UIButton *cancel_btn;
@property (weak, nonatomic) IBOutlet UIButton *tip_btn;
@property (weak, nonatomic) IBOutlet UIButton *sure_receipt;
@property (assign, nonatomic) NSInteger index;
@end
