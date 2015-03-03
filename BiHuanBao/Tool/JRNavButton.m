//
//  JRNavButton.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/25.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "JRNavButton.h"

#define Width 20.f
#define Height 20.f
#define distanceWithLableAndImageView 2
#define kImageBiLi 0.3
@implementation JRNavButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - 重写了UIButton的方法
#pragma mark -控制UILabel的位置和尺寸
//contentRect 其实就是按钮的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = self.imageView.frame.origin.x+self.imageView.frame.size.width;
    CGFloat titleHeight = Height;
    CGFloat titleY = (contentRect.size.height-Height)/2.0;
    CGFloat titleWidth = contentRect.size.width-(titleX);
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

#pragma mark - 控制UIImageView的位置和尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = (contentRect.size.width-Width)/2.0;
    CGFloat imageY = (contentRect.size.height-Height)/2.0;
    CGFloat imageWidth = Width;
    CGFloat imageHeight = Height;
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}
@end
