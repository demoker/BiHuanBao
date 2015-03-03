//
//  CorpOrderDetailViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderItem.h"
@interface CorpOrderDetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (weak, nonatomic) IBOutlet UIButton *stockup_btn;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (retain, nonatomic) OrderItem * mitem;
@end