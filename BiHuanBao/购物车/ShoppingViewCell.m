//
//  ShoppingViewCell.m
//  BuyBuyring
//
//  Created by 易龙天 on 13-12-10.
//  Copyright (c) 2013年 易龙天. All rights reserved.
//

#import "ShoppingViewCell.h"

@implementation ShoppingViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
      
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
//    [_content_ImgV release];
//    [_content_name release];
//    [_content_price release];
//    [_content_num release];
//    [_totalTag release];
//    [_content_total release];
//    [_subBtn release];
//    [_addBtn release];
//    [_changeNum release];
//    [_deleteBtn release];
//    [_bottom_line release];
//    [_textfield_bg release];
//    [_tapLabel release];
//    [_selected_btn release];
//    [super dealloc];
}
@end
