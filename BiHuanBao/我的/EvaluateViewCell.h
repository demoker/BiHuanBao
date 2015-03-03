//
//  EvaluateViewCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/14.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELStarRatingView.h"
@interface EvaluateViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImg;
@property (weak, nonatomic) IBOutlet UILabel *want_evaluate;
@property (weak, nonatomic) IBOutlet UIImageView *want_icon;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (weak, nonatomic) IBOutlet ELStarRatingView *star;
@property (weak, nonatomic) IBOutlet UIImageView *input_bg;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextView *text_view;

@end
