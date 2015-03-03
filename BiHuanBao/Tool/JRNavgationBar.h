//
//  JRNavgationBar.h
//  Mtest
//
//  Created by elongtian on 13-10-22.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRNavButton.h"
@protocol JRNavDelegate <NSObject>
@optional
- (void)back:(id)sender; //返回
- (void)home:(id)sender; //返回主页
- (void)bed:(id)sender; //进入客房
- (void)call:(id)sender; //拨打电话
- (void)set:(id)sender; //设置
- (void)share:(id)sender;// 分享
- (void)done:(id)sender;
- (void)titleTap:(id)sender;
- (void)swipetoDown:(UISwipeGestureRecognizer *)swipe;
@required



@end


@class JRNavgationBar;
typedef enum {
    
    JRNAVGATIONDEFAULTBAR,//默认，只显示back和主页
    
    JRNAVGATIONSHOWBAR,//展示界面 显示back，主页，床，call
    
    JRNAVGATIONLOGINBAR,//登录界面 只有back
    
    JRNAVGATIONSHOWHEADBAR,//展示首页，包含back，call，主页
    
    JRNAVGATIONACTIVITYBAR,//活动最终 back和分享
    
    JRNAVGATIONSETTINGBAR, //个人信息界面，包含设置，back，主页
    
    JRNAVGATIONSETTING,//我的京瑞界面，包含设置、返回。
    JRNAVGATIONDONE //done
    
    
}JRNAVGATIONTYPE;

@interface JRNavgationBar : UIView
{
    CGPoint begin;
    CGPoint end;
    JRNAVGATIONTYPE typpe;
}
@property (retain, nonatomic) UIButton * backbtn;
@property (retain, nonatomic) UIButton * homebtn;
@property (retain, nonatomic) UIButton * callbtn;
@property (retain, nonatomic) UIButton * bedbtn;
@property (retain, nonatomic) UIButton * setbtn;
@property (retain, nonatomic) UIButton * sharebtn;
@property (retain, nonatomic) UIButton * done;
@property (retain, nonatomic) UIImageView * bg_imageView;
@property (retain, nonatomic) UILabel * titleLabel;
@property (assign, nonatomic) id<JRNavDelegate>delegate;
@property (retain, nonatomic) UIImageView * title_bg_view;
- (id)initWithFrame:(CGRect)frame Option:(JRNAVGATIONTYPE)type;

@end
