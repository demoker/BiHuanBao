//
//  CouponListCollectionCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/9.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponListCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mark_icon;
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *pass_key;
@property (weak, nonatomic) IBOutlet UIButton *operation_btn;
@property (weak, nonatomic) IBOutlet UILabel *evaluate_state;

@end
