//
//  CouponDetailViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponListItem.h"
@interface CouponDetailViewController : BaseViewController
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UIView *top_backView;
@property (weak, nonatomic) IBOutlet UIImageView *tag_icon;
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *pass_key;
@property (weak, nonatomic) IBOutlet UIView *qrcode_backView;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImg;
@property (retain, nonatomic) CouponListItem * mitem;
@end
