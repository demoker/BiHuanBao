//
//  CorpCouponListController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "CorpCouponList.h"
@interface CorpCouponListController : BaseViewController
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UIButton *no_useBtn;
@property (weak, nonatomic) IBOutlet UIButton *did_useBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (retain, nonatomic) CorpCouponList * no_list;
@property (retain, nonatomic) CorpCouponList * did_list;

@end
