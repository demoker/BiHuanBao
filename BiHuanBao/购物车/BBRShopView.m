//
//  BBRShopView.m
//  BuyBuyring
//
//  Created by elongtian on 14-2-19.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "BBRShopView.h"

@implementation BBRShopView
@synthesize badgeview;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        badgeview = [[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentTopRight];
        [self addSubview:badgeview];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        badgeview = [[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentTopRight];
        [self addSubview:badgeview];
        
    }
    return self;
}

- (void)dealloc
{
//    [badgeview release];
//    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
