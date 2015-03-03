//
//  ShopCarHeadCell.m
//  BuyBuyring
//
//  Created by elongtian on 14-2-27.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "ShopCarHeadCell.h"

@implementation ShopCarHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
//    [_merchantName release];
//    [super dealloc];
}
@end
