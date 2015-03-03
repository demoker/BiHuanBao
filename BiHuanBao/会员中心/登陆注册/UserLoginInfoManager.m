//
//  UserLoginInfoManager.m
//  BuyBuyring
//
//  Created by elongtian on 14-1-16.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "UserLoginInfoManager.h"

static UserLoginInfoManager * manager;
@implementation UserLoginInfoManager
@synthesize user;
@synthesize pwd;//密码我在登录成功的时候存在单例中的是md5编码的
@synthesize state;
@synthesize coor;
@synthesize current_coor;
@synthesize currentCity;

- (id)init
{
    if(self = [super init])
    {
        self.state = NO;
    }
    return self;
}
//- (void)setUser:(NSString *)user{
//    self.user = @"test@qq.com";
//}
//- (void)setPwd:(NSString *)pwd
//{
//    self.pwd = @"202cb962ac59075b964b07152d234b70";
//}
//- (NSString *)user
//{
//    return @"test@qq.com";
//}
//- (NSString *)pwd
//{
//    return @"202cb962ac59075b964b07152d234b70";
//}
+ (UserLoginInfoManager *)loginmanager
{
    if(manager == nil)
    {
        manager = [[UserLoginInfoManager alloc] init];
    }
    return manager;//记得这里加同步锁
}


@end
