//
//  MyBiDestineController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/10.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface MyBiDestineController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    JRNavgationBar * navBar;
    int more;
    BOOL is_close;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) NSIndexPath * selectedIndexpath;
@property (retain, nonatomic) NSMutableArray * dataarray;
@end
