//
//  ProductFinalEvaluateCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELStarRatingView.h"
@interface ProductFinalEvaluateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *content_titleImg;
@property (weak, nonatomic) IBOutlet UILabel *content_user;
@property (weak, nonatomic) IBOutlet ELStarRatingView *star;
@property (weak, nonatomic) IBOutlet UILabel *content_time;
@property (weak, nonatomic) IBOutlet UILabel *content_body;
@property (weak, nonatomic) IBOutlet UIImageView *back_img;
@property (weak, nonatomic) IBOutlet UIImageView *line;

@end
