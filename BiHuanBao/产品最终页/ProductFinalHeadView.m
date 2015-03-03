//
//  ProductFinalHeadView.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/11/30.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "ProductFinalHeadView.h"

@implementation ProductFinalHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize defaultImg;
@synthesize seeMore;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        defaultImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        defaultImg.contentMode = UIViewContentModeScaleAspectFit;
        [defaultImg setImage:[UIImage imageNamed:@"banner"]];
        [self addSubview:defaultImg];
        
        seeMore = [UIButton buttonWithType:UIButtonTypeCustom];
        seeMore.frame = CGRectMake(0, 0, 120, 30);
        seeMore.titleLabel.text = @"查看更多";
        seeMore.center = CGPointMake(frame.size.width/2, frame.size.height-25);
        [self addSubview:seeMore];
        
        
    }
    return self;
}

@end
