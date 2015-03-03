//
//  BixvSongFinalViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BixvSongFinalViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UIImageView *renzheng1;
@property (weak, nonatomic) IBOutlet UIImageView *renzheng2;
@property (weak, nonatomic) IBOutlet UILabel *content_desc;
@property (weak, nonatomic) IBOutlet UILabel *giving;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *yu_e;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *site;
@property (weak, nonatomic) IBOutlet UIImageView *callBtn;
@property (weak, nonatomic) IBOutlet UIButton *yuyueBtn;
@end
