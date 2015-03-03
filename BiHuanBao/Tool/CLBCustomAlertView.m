//
//  CustomAlertView.m
//  CustomAlertViewDemo
//
//  Created by wei on 14-4-3.
//  Copyright (c) 2014年 vcyber. All rights reserved.
//

#import "CLBCustomAlertView.h"
#import "UILabel+Resize.h"

#define AlertWidth        245
#define titleLable_height 40

#define buttonWidth       75.0f
#define buttonHeight      30.5f

#define labelOffset       20.0f
#define buttonSpace       ((AlertWidth-buttonWidth*2)/3)

#define allWidth    [UIScreen mainScreen].bounds.size.width
#define allHeight   [UIScreen mainScreen].bounds.size.height

@interface CLBCustomAlertView ()



@property (nonatomic,strong)NSMutableAttributedString *titleAttributed;
@property (nonatomic,strong)NSMutableAttributedString *messageAttributed;

@property (nonatomic,strong)ActionBlock leftButtonActionBlock;
@property (nonatomic,strong)ActionBlock rightButtonActionBlock;

@end

@implementation CLBCustomAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitle:(NSString *)title
           message:(NSString *)message
   leftButtonTitle:(NSString *)leftTitle
   leftActionBlock:(ActionBlock)letfActionBlock
  rightButtonTitle:(NSString *)rightTitle
  rightActionBlock:(ActionBlock)rightActionBlock
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.0;
        
        _leftButtonActionBlock = letfActionBlock;
        _rightButtonActionBlock = rightActionBlock;
        
        self.titleLabel = [[UILabel alloc]init];
        if (title == nil) {
            self.titleLabel.frame = CGRectMake(labelOffset, 20, AlertWidth - labelOffset * 2, 0);
        }else{
            self.titleLabel.frame = CGRectMake(0, 20, AlertWidth, titleLable_height);
            self.titleLabel.text = title;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.backgroundColor = [UIColor clearColor];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = [UIFont systemFontOfSize:16];
            self.titleAttributed = [[NSMutableAttributedString alloc]initWithString:title];
            self.titleLabel.attributedText = self.titleAttributed;
            [self.titleLabel resizeHeightToFitText];
            [self addSubview:self.titleLabel];
        }
        
        self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelOffset, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y+5, AlertWidth - labelOffset * 2, 20)];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.font = [UIFont systemFontOfSize:14];

        if (message == nil) {
            message = NSLocalizedString(@"None", nil);
        }
        self.messageAttributed = [[NSMutableAttributedString alloc]initWithString:message];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        paragraph.alignment = NSTextAlignmentCenter;
        paragraph.lineSpacing = 3.0;//设置行间距
        [self.messageAttributed addAttribute:NSParagraphStyleAttributeName
                                       value:paragraph
                                       range:NSMakeRange(0, message.length)];
        self.messageLabel.attributedText = self.messageAttributed;
        [self.messageLabel resizeHeightToFitText];
        CGRect messageFrame = self.messageLabel.frame;
        if (messageFrame.size.height>([[UIScreen mainScreen] bounds].size.height-150)) {
            messageFrame.size.height = [[UIScreen mainScreen] bounds].size.height-150;
            self.messageLabel.frame = messageFrame;
        }
        self.messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:self.messageLabel];
        
        //左侧按钮，高亮
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSLog(@"%f",CGRectGetMinY(self.messageLabel.frame));
        self.leftButton.frame = CGRectMake(buttonSpace, CGRectGetMaxY(self.messageLabel.frame)+15, buttonWidth, buttonHeight);
        [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
//        [self.leftButton setBackgroundImage:[UIImage imageNamed:@"orange_btn_bg"]
//                                   forState:UIControlStateNormal];
        if(rightTitle == nil)
        {
            [self.leftButton setBackgroundColor:UIColorFromRGB(0xfe4e01)];
        }
        else
        {
            [self.leftButton setBackgroundColor:UIColorFromRGB(0xbebebe)];
        }
        self.leftButton.layer.cornerRadius = 5;
        [self.leftButton addTarget:self
                            action:@selector(leftButtonClicked)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftButton];
        
        //右侧按钮，取消
        if (rightTitle != nil) {
            self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.rightButton.frame = CGRectMake(buttonSpace*2+buttonWidth, CGRectGetMaxY(self.messageLabel.frame)+15, buttonWidth, buttonHeight);
            [self.rightButton setBackgroundColor:UIColorFromRGB(0xfe4e01)];
            [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
            [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            self.rightButton.layer.cornerRadius = 5;
            [self.rightButton addTarget:self
                                 action:@selector(rightButtonClicked)
                       forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.rightButton];
        }else{
            //没有右侧按钮
            self.leftButton.frame = CGRectMake((AlertWidth - 120)/2, CGRectGetMaxY(self.messageLabel.frame)+15, 120, buttonHeight);
        }
    }
    return self;
}

-(void)show{
    UIViewController *topVC = [self appRootViewController];
    CGFloat alertHeight = CGRectGetMaxY(self.leftButton.frame) + 20;
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - AlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds)-alertHeight)/2, AlertWidth, alertHeight);
    [topVC.view addSubview:self];
}

- (void)dismiss
{
    [self remove];
}

- (void)showInView:(UIView *)superView{
    CGFloat alertHeight = CGRectGetMaxY(self.leftButton.frame) + 20;
    self.frame = CGRectMake((CGRectGetWidth(superView.bounds) - AlertWidth) * 0.5,
                            (CGRectGetHeight(superView.bounds)-alertHeight)/2,
                            AlertWidth,
                            alertHeight);
    [superView addSubview:self];
}

- (void)setTextAlignment:(NSInteger)textAlignment
{
    _textAlignment = textAlignment;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    paragraph.lineSpacing = 3.0;//设置行间距
    if (_textAlignment == MessageTextAlignmentCenter) {
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        paragraph.alignment = NSTextAlignmentCenter;
    }else if(_textAlignment == MessageTextAlignmentLeft){
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        paragraph.alignment = NSTextAlignmentLeft;
    }else if (_textAlignment == MessageTextAlignmentRight){
        self.messageLabel.textAlignment = NSTextAlignmentRight;
        paragraph.alignment = NSTextAlignmentRight;
    }
    [self.messageAttributed addAttribute:NSParagraphStyleAttributeName
                                   value:paragraph
                                   range:NSMakeRange(0, self.messageLabel.text.length)];
    self.messageLabel.attributedText = self.messageAttributed;
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (newSuperview == nil) {
        return;
    }
    
    if (!self.backView) {
        self.backView = [[UIView alloc]initWithFrame:newSuperview.bounds];
        self.backView.backgroundColor = [UIColor blackColor];
        self.backView.alpha = 0.6f;
        self.backView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
//    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    // animation.timingFunction = kCAMediaTimingFunctionEaseIn;
    [self.layer addAnimation:animation forKey:nil];
    
    [newSuperview addSubview:self.backView];
    [super willMoveToSuperview:newSuperview];
}

-(void)remove{
    [self.backView removeFromSuperview];
    self.backView = nil;
    //在此添加动画
    
    
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    //    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.0)]];
    animation.values = values;
    // animation.timingFunction = kCAMediaTimingFunctionEaseIn;
    [self.layer addAnimation:animation forKey:nil];
    
    [self removeFromSuperview];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [super removeFromSuperview];
    }
}
-(void)leftButtonClicked{
    if (!_leftButtonActionBlock) {
        return;
    }
    _leftButtonActionBlock(self);

}

-(void)rightButtonClicked{
    if (!_rightButtonActionBlock) {
        return;
    }
    _rightButtonActionBlock(self);
}

-(void)setTitleColor:(UIColor *)color forRange:(NSRange)range{
    [self.titleAttributed addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.titleLabel.attributedText = self.titleAttributed;
}

-(void)setTitleFont:(UIFont *)font forRagne:(NSRange)range{
    [self.titleAttributed addAttribute:NSFontAttributeName value:font range:range];
    self.titleLabel.attributedText = self.titleAttributed;
    [self.titleLabel resizeHeightToFitText];
    // [self resetSubviews];
}

-(void)setMessageColor:(UIColor *)color forRange:(NSRange)range{
    [self.messageAttributed addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.messageLabel.attributedText = self.messageAttributed;
}

-(void)setMessageFont:(UIFont *)font forRagne:(NSRange)range{
    [self.messageAttributed addAttribute:NSFontAttributeName value:font range:range];
    self.messageLabel.attributedText = self.messageAttributed;
    [self.messageLabel resizeHeightToFitText];
    // [self resetSubviews];
}

-(void)resetSubviews{
    self.messageLabel.frame = CGRectMake(labelOffset, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y+5, AlertWidth - labelOffset * 2, 20);
    self.leftButton.frame = CGRectMake(buttonSpace, CGRectGetMaxY(self.messageLabel.frame)+10, buttonWidth, buttonHeight);
    self.rightButton.frame = CGRectMake(buttonSpace*2+buttonWidth, CGRectGetMaxY(self.messageLabel.frame)+10, buttonWidth, buttonHeight);
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
