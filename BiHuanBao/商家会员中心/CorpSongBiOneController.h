//
//  CorpSongBiOneController.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/3.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface CorpSongBiOneController : BaseViewController
{
    JRNavgationBar * navBar;
}
@property (weak, nonatomic) IBOutlet UIView *no_kai_view;
@property (weak, nonatomic) IBOutlet UIView *had_kai_view;
@property (weak, nonatomic) IBOutlet UILabel *total_label;
@property (weak, nonatomic) IBOutlet UILabel *had_label;
@property (weak, nonatomic) IBOutlet UILabel *yu_e_label;
@property (weak, nonatomic) IBOutlet UIButton *song_btn;

@property (retain, nonatomic) NSString * content_name;
@property (retain, nonatomic) NSString * content_stotal;
@property (retain, nonatomic) NSString * true_price;
@property (retain, nonatomic) NSString * book_price;
@property (retain, nonatomic) NSString * content_status;
@property (retain, nonatomic) NSString * ye_price;
@property (retain, nonatomic) NSString * auto_id;

@property (retain, nonatomic) NSString * corp_id;


@end
