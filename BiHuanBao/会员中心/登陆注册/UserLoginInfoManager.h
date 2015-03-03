//
//  UserLoginInfoManager.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-16.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
@interface UserLoginInfoManager : NSObject
@property (retain, nonatomic) NSString * user;//用户名称
@property (retain, nonatomic) NSString * pwd;//登陆密码
@property (assign, nonatomic) BOOL state;//登陆状态
@property (retain, nonatomic) NSString * isCorper;//表示商家会员 1用户会员 2商家会员
@property (assign, nonatomic) CLLocationCoordinate2D coor;//当前选择的商户经纬度
@property (assign, nonatomic) CLLocationCoordinate2D current_coor;//自己当前的位置

@property (retain, nonatomic) NSString * currentCity;
+ (UserLoginInfoManager *)loginmanager;

@end
