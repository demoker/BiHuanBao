//
//  B2CRootHeaderView.m
//  elongtianB2C
//
//  Created by elongtian on 14-4-29.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "B2CRootHeaderView.h"

@implementation B2CRootHeaderView
@synthesize defaultImg;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        defaultImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [defaultImg setImage:[UIImage imageNamed:@"banner"]];
        [self addSubview:defaultImg];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
//    [_mscrollView release];
//    [_searchTextField release];
//    [_scanBtn release];
//    [_mpagecontrol release];
//    [super dealloc];
}
@end
