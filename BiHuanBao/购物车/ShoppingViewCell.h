//
//  ShoppingViewCell.h
//  BuyBuyring
//
//  Created by 易龙天 on 13-12-10.
//  Copyright (c) 2013年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *bottom_line;
@property (retain, nonatomic) IBOutlet UIImageView *content_ImgV;
@property (retain, nonatomic) IBOutlet UILabel *content_name;
@property (retain, nonatomic) IBOutlet UILabel *content_price;
@property (retain, nonatomic) IBOutlet UILabel *content_num;
@property (retain, nonatomic) IBOutlet UILabel *totalTag;
@property (retain, nonatomic) IBOutlet UILabel *content_total;
@property (retain, nonatomic) IBOutlet UIButton *subBtn;
@property (retain, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (retain, nonatomic) IBOutlet UILabel *changeNum;
@property (retain, nonatomic) IBOutlet UIButton *deleteBtn;
@property (retain, nonatomic) IBOutlet UIImageView *textfield_bg;
@property (retain, nonatomic) IBOutlet UIButton *selected_btn;

@end
