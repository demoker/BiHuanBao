//
//  TotalTableViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalmoney;
@property (weak, nonatomic) IBOutlet UILabel *totalnum;
@property (weak, nonatomic) IBOutlet UILabel *order_sn;
@property (weak, nonatomic) IBOutlet UILabel *order_time;
@property (weak, nonatomic) IBOutlet UILabel *num_tag;
@property (weak, nonatomic) IBOutlet UILabel *order_sn_tag;

@end
