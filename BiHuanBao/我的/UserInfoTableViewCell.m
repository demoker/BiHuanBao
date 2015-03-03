//
//  UserInfoTableViewCell.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

     [self.email resignFirstResponder];
     [self.username resignFirstResponder];
     [self.mobile resignFirstResponder];
     [self.address resignFirstResponder];
     [self.contact resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
