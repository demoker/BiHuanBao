//
//  WalletRecordCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/7.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fangxiang_Img;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *address_label;
@property (weak, nonatomic) IBOutlet UILabel *number_label;
@property (weak, nonatomic) IBOutlet UILabel *btc_label;

@end
