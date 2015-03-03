//
//  CouponListCellView.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/3.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponListCellView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *mark_icon;
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *pass_key;
@property (weak, nonatomic) IBOutlet UIButton *operation_btn;
@property (weak, nonatomic) IBOutlet UILabel *evaluate_state;
@end
