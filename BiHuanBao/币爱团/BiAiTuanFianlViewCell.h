//
//  BiAiTuanFianlViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELStarRatingView.h"
@interface BiAiTuanFianlViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *corp_name;
@property (weak, nonatomic) IBOutlet UIImageView *renzheng1;
@property (weak, nonatomic) IBOutlet UIImageView *renzheng2;
@property (weak, nonatomic) IBOutlet UILabel *content_desc;
@property (weak, nonatomic) IBOutlet UILabel *content_price;
@property (weak, nonatomic) IBOutlet UIButton *iwantTuan;
@property (weak, nonatomic) IBOutlet UILabel *baotui;
@property (weak, nonatomic) IBOutlet UIImageView *baotui_icon;
@property (weak, nonatomic) IBOutlet UILabel *numbers;
@property (weak, nonatomic) IBOutlet ELStarRatingView *star;
@property (weak, nonatomic) IBOutlet UILabel *evaulates;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *site;
@property (weak, nonatomic) IBOutlet UIImageView *callBtn;

@end
