//
//  ReturnGoodsCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/27.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnGoodsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *corp_name;
@property (weak, nonatomic) IBOutlet UILabel *content_price;
@property (weak, nonatomic) IBOutlet UILabel *content_num;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line;

@end
