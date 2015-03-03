//
//  CorpCouponTableCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELStarRatingView.h"
@interface CorpCouponTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UIImageView *shop_type_img;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *sub_title;
@property (weak, nonatomic) IBOutlet UILabel *lj_num;
@property (weak, nonatomic) IBOutlet ELStarRatingView *star;
@property (weak, nonatomic) IBOutlet UILabel *comment_num;

@end
