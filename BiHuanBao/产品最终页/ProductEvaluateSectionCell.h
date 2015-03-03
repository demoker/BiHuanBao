//
//  ProductEvaluateSectionCell.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELStarRatingView.h"
@interface ProductEvaluateSectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ELStarRatingView *star;
@property (weak, nonatomic) IBOutlet UILabel *content_number;
@end
