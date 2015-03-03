//
//  PrepareGoodsViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderItem.h"
#import "QrCodeScanningController.h"
@interface PrepareGoodsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,QrCodeScanningDelegate>
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) OrderItem * mitem;
@property (assign, nonatomic) BOOL is_return;//退货
@property (assign, nonatomic) NSInteger index;
@end
