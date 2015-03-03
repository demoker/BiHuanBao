//
//  OrderListThreeProCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/11.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListThreeProCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *corp_name;
@property (weak, nonatomic) IBOutlet UIImageView *content_img1;
@property (weak, nonatomic) IBOutlet UIImageView *content_img2;
@property (weak, nonatomic) IBOutlet UIImageView *content_img3;
@property (weak, nonatomic) IBOutlet UILabel *content_total;
@property (weak, nonatomic) IBOutlet UILabel *content_sn;
@property (weak, nonatomic) IBOutlet UILabel *content_num;
@property (weak, nonatomic) IBOutlet UILabel *order_state;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (weak, nonatomic) IBOutlet UILabel *create_time;
@end
