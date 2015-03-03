//
//  PrepareGoodsTableCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/16.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrepareGoodsTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *username_tag;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *content_address;
@property (weak, nonatomic) IBOutlet UILabel *consignee;
@property (weak, nonatomic) IBOutlet UILabel *content_mobile;
@property (weak, nonatomic) IBOutlet UILabel *content_num;
@property (weak, nonatomic) IBOutlet ELTextField *expressName;
@property (weak, nonatomic) IBOutlet ELTextField *express_id_textField;
@property (weak, nonatomic) IBOutlet UIButton *scan_btn;
@property (weak, nonatomic) IBOutlet UIButton *cancel_btn;
@property (weak, nonatomic) IBOutlet UIButton *sure_btn;

@end
