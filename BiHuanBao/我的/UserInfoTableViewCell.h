//
//  UserInfoTableViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ELTextField *email;
@property (weak, nonatomic) IBOutlet ELTextField *username;
@property (weak, nonatomic) IBOutlet ELTextField *mobile;
@property (weak, nonatomic) IBOutlet ELTextField *contact_link;//默认联系方式
@property (weak, nonatomic) IBOutlet UITextView *address;
@property (weak, nonatomic) IBOutlet ELTextField *contact;
@property (weak, nonatomic) IBOutlet UIImageView *content_titleImg;
@property (weak, nonatomic) IBOutlet UIButton *commit;
@property (weak, nonatomic) IBOutlet UIImageView *textview_bg;

@end
