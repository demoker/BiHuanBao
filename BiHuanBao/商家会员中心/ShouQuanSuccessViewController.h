//
//  ShouQuanFailedViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/2.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponListItem.h"
@interface ShouQuanSuccessViewController : BaseViewController
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UIImageView *content_tag_icon;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *content_code;
@property (weak, nonatomic) IBOutlet UIView *content_view;

@property (weak, nonatomic) IBOutlet UILabel *sub_label;
@property (weak, nonatomic) IBOutlet UIButton *cancel_btn;
@property (weak, nonatomic) IBOutlet UIButton *sure_btn;
@property (weak, nonatomic) IBOutlet UIImageView *sucess_ok;

@property (retain, nonatomic) NSString * autoid;
@property (retain, nonatomic) NSString * s_code;
@property (retain, nonatomic) CouponListItem * mitem;
@end
