//
//  CustomAlertView.h
//  CustomAlertViewDemo
//
//  Created by wei on 14-4-3.
//  Copyright (c) 2014年 vcyber. All rights reserved.
//

//实现了系统的弹出动画
//自定义按钮和事件
//内容可支持多种字体和颜色
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MessageTextAlignment){
    MessageTextAlignmentCenter = 0,
    MessageTextAlignmentLeft = 1,
    MessageTextAlignmentRight = 2,
};

@interface CLBCustomAlertView : UIView

typedef void(^ActionBlock)(CLBCustomAlertView *view);

@property (nonatomic,assign)NSInteger textAlignment;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *messageLabel;
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *rightButton;
-(id)initWithTitle:(NSString *)title
           message:(NSString *)message
   leftButtonTitle:(NSString *)leftTitle
   leftActionBlock:(ActionBlock)letfActionBlock
  rightButtonTitle:(NSString *)rightTitle
   rightActionBlock:(ActionBlock)rightActionBlock;

//显示到navigation.view上
-(void)show;
- (void)dismiss;
//显示到指定的view上
- (void)showInView:(UIView *)superView;

- (void)setTextAlignment:(NSInteger)textAlignment;//default 居中

-(void)setTitleColor:(UIColor *)color forRange:(NSRange)range;
-(void)setTitleFont:(UIFont *)font forRagne:(NSRange)range;
-(void)setMessageColor:(UIColor *)color forRange:(NSRange)range;
-(void)setMessageFont:(UIFont *)font forRagne:(NSRange)range;

@end
