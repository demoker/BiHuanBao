//
//  MyBiDestineTableCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/10.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBiDestineTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *corp_name;
@property (weak, nonatomic) IBOutlet UILabel *content_result;
@property (weak, nonatomic) IBOutlet UIButton *delete_btn;
@property (weak, nonatomic) IBOutlet UIImageView *bg_img;
@end
