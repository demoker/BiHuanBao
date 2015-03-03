//
//  CorpSongBiTwoController.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/3.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "ELTextField.h"
@interface CorpSongBiTwoController : BaseViewController
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UIButton *qrCodeMake_btn;
@property (weak, nonatomic) IBOutlet ELTextField *input;

@property (retain, nonatomic) NSString * auto_id;
@property (retain, nonatomic) NSString * corp_id;
@property (retain, nonatomic) NSString * btc_price;
@property (retain, nonatomic) NSString * yu_e;
@end
