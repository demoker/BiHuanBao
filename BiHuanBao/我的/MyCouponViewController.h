//
//  MyCouponViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/9.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "CouponListViewController.h"
@interface MyCouponViewController : BaseViewController
{
    JRNavgationBar * navBar;
    CouponListViewController * no_list;
    CouponListViewController * did_list;
}
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UIButton *no_use_btn;
@property (weak, nonatomic) IBOutlet UIButton *did_use_btn;

@end
