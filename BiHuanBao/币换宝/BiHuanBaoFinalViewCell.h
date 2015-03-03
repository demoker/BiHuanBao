//
//  BiHuanBaoFinalViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELStarRatingView.h"
@interface BiHuanBaoFinalViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIImageView *renzheng1;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *content_price;
@property (weak, nonatomic) IBOutlet UILabel *region;
@property (weak, nonatomic) IBOutlet UILabel *xiaoliang;
@property (weak, nonatomic) IBOutlet UILabel *total_xiaoliang;
@property (weak, nonatomic) IBOutlet UILabel *kucun;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet ELStarRatingView *star;
@property (weak, nonatomic) IBOutlet UIButton *addShopCar;

@end
