//
//  OderListHeaderCell.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-21.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OderListHeaderCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *merchantName;
@property (retain, nonatomic) IBOutlet UILabel *oderState;
@property (retain, nonatomic) IBOutlet UILabel *order_idLabel;
@property (strong, nonatomic) IBOutlet UIView *listheadbg;

@end
