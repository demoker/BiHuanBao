//
//  CorpCouponList.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface CorpCouponList : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) NSMutableArray * dataarray;
@property (retain, nonatomic) NSString * task;
@property (assign, nonatomic) id delegate;
@end
