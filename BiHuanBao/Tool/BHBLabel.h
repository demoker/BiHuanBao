//
//  BHBLabel.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/24.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHBLabel : UILabel
// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length;
@end
