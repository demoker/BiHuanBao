//
//  MyBiDestineTableViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/10.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBiDestineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bg_img;
@property (weak, nonatomic) IBOutlet UILabel *corp_name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *site;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *destine_num;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UILabel *yjsc_num;
@property (weak, nonatomic) IBOutlet UILabel *ljyy_num;
@property (weak, nonatomic) IBOutlet UIButton *cancel_btn;
@property (weak, nonatomic) IBOutlet UIButton *souqi_btn;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIView *cover_bg;
@property (weak, nonatomic) IBOutlet UIImageView *result_icon;
@property (weak, nonatomic) IBOutlet UILabel *result_desc;

@end
