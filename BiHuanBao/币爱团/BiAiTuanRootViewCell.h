//
//  BiAiTuanRootViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELStarRatingView.h"
@interface BiAiTuanRootViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UIImageView *img_tag;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *content_desc;
@property (weak, nonatomic) IBOutlet UILabel *content_price;
@property (weak, nonatomic) IBOutlet ELStarRatingView *star;

@end
