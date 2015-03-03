//
//  CorpCommentsController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "CorpCouponTableCell.h"
#import "CorpCouponItem.h"
@interface CorpCommentsController : BaseViewController<UITableViewDataSource,UITableViewDelegate,TableViewDelegate>
{
    JRNavgationBar * navBar;
    CorpCouponTableCell * singlecell;
    int more;
}
@property (weak, nonatomic) IBOutlet TableView *mtableview;

@property (retain, nonatomic) NSString * auto_id;
@property (retain, nonatomic) NSMutableArray * evaluates;
@property (retain, nonatomic) CorpCouponItem * mitem;
@end
