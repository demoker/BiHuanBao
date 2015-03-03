//
//  RootTableViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/27.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *content_img;
@property (weak, nonatomic) IBOutlet UILabel *content_name;
@property (weak, nonatomic) IBOutlet UILabel *sub_title;
@property (weak, nonatomic) IBOutlet UILabel *content_preprice;
@property (weak, nonatomic) IBOutlet UILabel *content_sale;
@property (weak, nonatomic) IBOutlet UIImageView *content_isnew;

@end
