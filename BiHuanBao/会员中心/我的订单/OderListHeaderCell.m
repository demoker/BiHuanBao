//
//  OderListHeaderCell.m
//  BuyBuyring
//
//  Created by elongtian on 14-1-21.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "OderListHeaderCell.h"

@implementation OderListHeaderCell

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
//    [_oderState release];
//    [_order_idLabel release];
//    [super dealloc];
}
@end
