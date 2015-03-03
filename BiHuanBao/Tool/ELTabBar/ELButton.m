//
//  ELButton.m
//  EYLife
//
//  Created by elongtian on 14-7-31.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//
#define kImageBiLi 0.3
#define distanceWithLableAndImageView 5

#import "ELButton.h"

@implementation ELButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

#pragma mark - 重写了UIButton的方法
#pragma mark 控制UILabel的位置和尺寸
// contentRect其实就是按钮的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * (1 - kImageBiLi) - distanceWithLableAndImageView;
    CGFloat titleY = contentRect.size.height - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

#pragma mark 控制UIImageView的位置和尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = (self.frame.size.width-23)/2.0;
    CGFloat imageY = 5;
    CGFloat imageWidth = 23;
    CGFloat imageHeight = contentRect.size.height * kImageBiLi;
    return CGRectMake(imageX, imageY, imageWidth, 23);
}

@end
