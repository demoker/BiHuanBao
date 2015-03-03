//
//  Address2TableViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Address2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *address_tag;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *contact_tag;
@property (weak, nonatomic) IBOutlet UILabel *contact;
@property (weak, nonatomic) IBOutlet UILabel *tel_tag;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UIImageView *bottom_line;
@property (weak, nonatomic) IBOutlet UIImageView *top_line;
@property (weak, nonatomic) IBOutlet UILabel *express_name;
@property (weak, nonatomic) IBOutlet UILabel *express_tag;
@end
