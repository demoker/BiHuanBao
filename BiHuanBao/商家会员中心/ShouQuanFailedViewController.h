//
//  ShouQuanSuccessViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/2.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface ShouQuanFailedViewController : BaseViewController
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UILabel *sub_label;
@property (weak, nonatomic) IBOutlet UIButton *cancel_btn;
@property (weak, nonatomic) IBOutlet UIButton *sure_btn;

@end
