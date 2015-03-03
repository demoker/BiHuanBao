//
//  Const.h
//  ilpUser
//
//  Created by elongtian on 14-6-5.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import <Foundation/Foundation.h>


//宏定义
//


//通知
#define StockedUpNotification @"StockedUpNotification"//开始备货
#define DeliveryedNotification @"DeliveryedNotification"//发货成功
#define EvaluateOrderNotification @"EvaluateOrderNotification"//评价成功
#define ReturnGoodsNotification @"ReturnGoodsNotification"//退货成功
#define SureReceiptNotification @"SureReceiptNotification"//确认收货
#define CancelOrderNotification @"CancelOrderNotification"//取消订单
#define CorpSureReceiptNotification @"CorpSureReceiptNotification"//商家签收成功

//评论通知
#define EvaluateOrderNotification @"EvaluateOrderNotification"//订单评论
#define EvaluateQuanNotification @"EvaluateQuanNotification" //券评论

//券退货成功
#define RefundQuanNotification @"RefundQuanNotification"

//送币预约接受成功
#define ShouQuanSuccessNotification @"ShouQuanSuccessNotification"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define SCREENWIDTH      CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREENHEIGHT      CGRectGetHeight([UIScreen mainScreen].bounds)
#define DELE [[UIApplication sharedApplication] delegate]
#define IOS7 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7

#define IOS8 [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=8

#define NSLogFrame(v) NSLog(@"%f,%f,%f,%f",v.frame.origin.x,v.frame.origin.y,v.frame.size.width,v.frame.size.height);

#define BackGround_Color UIColorFromRGB(0xf0f0f0)

#define NSStringFromJson(v) (([v isEqual:[NSNull null]])?@"":v)
#define OBJC(v) (([v isEqual:[NSNull null]])?nil:v)
#define OBJC_REPLACE(v,r) (([v isEqual:[NSNull null]]||[v length]==0)?r:v)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif



#define APPID @"888941676"

#define NAVHEIGHT (IOS7?64:44)
#define IphoneHeight [UIScreen mainScreen].bounds.size.height

#define USER_NAME @"user"
#define USER_PWD @"pwd"

#define LOADING @"正在加载..."

#define NO_MORE_DATA @"就这么多了"

#define NO_NET @"请检查您的网络"
#define NO_NET_DESC @"数据加载失败!"
#define NO_DATA_DESC @"暂无数据!"
#define ADD_SHOPCAR_SUCCESS @"添加购物车成功"

#define NSUserDefault_USER ([[NSUserDefaults standardUserDefaults] objectForKey:@"user"])
#define NSUserDefault_PWD ([[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"])

#define AreRemember @"isRemember"
#define is_Remember_Bool YES






#define HTTP @"http://test.b-bao.com/app/index.php?com=com_appService"

//分类
#define ClassesUrl @"&method=appSev&app_com=com_shop&task=shopClass"

//城市
#define CitysUrl @"&method=appSev&app_com=com_shop&task=areaBar"

#define GetBTCInfoUrl @"&method=appSev&app_com=com_shop&task=getBtcInfo"

#define GetClassessUrl @"&method=appSev&app_com=com_shop&task=shopClass"

//轮播图
#define AdvantageShowUrl @"&method=appSev&app_com=com_ad&task=lists&img_type=4"


//列表也
#define BiAiTuanListUrl @"&method=appSev&app_com=com_shop&task=plists&per=1"
#define BiHuanBaoListUrl @"&method=appSev&app_com=com_shop&task=proLists&per=1"
#define BiXvSongListUrl @"&method=appSev&app_com=com_shop&task=sentlists&per=1"
//详情页
#define BiAiTuanDetailUrl @"&method=appSev&app_com=com_shop&task=appbulkView"
#define BiHuanBaoDetailUrl @"&method=appSev&app_com=com_shop&task=appView"
#define BiXvSongDetailUrl @"&method=appSev&app_com=com_shop&task=sentview"
//更多评论
#define BiAiTuanMoreCommentsUrl @"&method=appSev&app_com=com_comment&task=shopLists&&plugin=com_shopBulk&per=1"
#define BiHuanBaoMoreCommentsUrl @"&method=appSev&app_com=com_comment&task=shopLists&&plugin=com_shopProduct&per=1"

//我要团
#define IWantTuanUrl @"&method=appSev&app_com=com_shoporder&task=appbulklists&plugin=com_shopBulk"
#define TuanCommitOrderUrl @"&method=save&app_com=com_shoporder&task=appaddOrder&type=bulk&plugin=com_shopBulk"
//必须送预约
#define CoinBookUrl @"&method=appSev&app_com=com_shop&task=coinBook"

#define CoinBookCommitUrl @"&method=save&app_com=com_shop&task=addCoinbook"


//购物车
#define AddShopCarUrl @"&method=appSev&app_com=com_shopcart&task=add&plugin=com_shopProduct"
#define EditShopCarUrl @"&method=appSev&app_com=com_shopcart&task=edit&plugin=com_shopProduct"
#define ShopCarCommitUrl @"&method=appSev&app_com=com_shoporder&task=appplists"
#define ShopCarEditUrl @"&method=appSev&app_com=com_shopcart&task=edit&plugin=com_shopProduct"
#define ShopCarCommitOrderUrl @"&method=save&app_com=com_shoporder&task=appaddOrder&type=index&plugin=com_shopProduct"

#define LoginUrl @"&method=save&app_com=com_passport&task=app_doLogin"
#define RegistUrl @"&method=save&app_com=com_passport&task=app_register"
#define GetVerificationCodeRegistUrl @""
//修改密码
#define ModifyPassWordUrl @"&method=save&app_com=com_passport&task=app_editPwd"

//会员信息编辑
#define UserInfoEditUrl @"&method=save&app_com=com_passport&task=app_editInfo"
#define UserInfoUrl @"&method=appSev&app_com=com_center&task=memberInfo"

//个人券列表
#define UserMyCouponUrl @"&method=appSev&app_com=com_pcenter"

//券退款
#define CouponRefundUrl @"&method=save&app_com=com_pcenter&task=returnBulk"

//评论接口（订单产品和券）
#define EvaluateQuanUrl @"&method=save&app_com=com_pcenter&task=saveComment"
#define EvaluateOrderUrl @"&method=save&app_com=com_pcenter&task=saveComment"

//个人、商家订单列表
#define OrderListUrl @"&method=appSev"
//取消订单
#define CancelOrderUrl @"&method=save&app_com=com_pcenter&task=cancelOrder"
//确认收货
#define SureReceiptUrl @"&method=save&app_com=com_pcenter&task=orderDelivery"
//退货
#define ReturnGoodsUrl @"&method=save&app_com=com_pcenter&task=saveReturnPro"
//商家确认收货
#define CorpSureReceiptUrl @"&method=save&app_com=com_ccenter&task=returnQs"

//发货
#define DeliveryUrl @"&method=save&app_com=com_ccenter&task=orderDelivery"
//个人会员必须送列表
#define PersonalBiDestineListUrl @"&method=appSev&app_com=com_pcenter&task=coinbook"

//必须送取消
#define PersonalBiCancelUrl @"&method=save&app_com=com_pcenter&task=cancelBook"
//接收赠送
#define GetGivingBtcUrl @"&method=save&app_com=com_pcenter&task=getCoinBook"

////////商家改订单为备货中
#define ChangeOrderStateStock @"&method=save&app_com=com_ccenter&task=changeStatus"

//商家券列表
#define CorpCouponListUrl @"&method=appSev&app_com=com_ccenter"

//商家收券
#define CorpShouCouponUrl @"&method=appSev&app_com=com_ccenter&task=unprolist"
//商家确认收券
#define CorpSureShouQuanUrl @"&method=save&app_com=com_ccenter&task=usePro"
#define CorpBiYuYueUrl @"&method=appSev&app_com=com_ccenter&task=coinSent"

//交易记录
#define JiaoYiJiLuUrl @"&method=appSev&app_com=com_pcenter&task=member_paylist"

//商家送币预约
#define CorpSongBiUrl @"&method=appSev&app_com=com_ccenter&task=coinSent"

//头文件
#import "JRNavgationBar.h"
#import "BaseViewController.h"
#import "UserLoginInfoManager.h"
#import "Product.h"
#import "Toast+UIView.h"
#import "JSONKit.h"
#import "ELHttpRequestOperation.h"
#import "UIImageView+AFNetworking.h"

#import "UserLocationSingle.h"

#import "FileMangerObject.h"

#import "ActivityIndicator.h"

#import "ELShareClient.h"


#import "ELTextField.h"

#import "ProductListItem.h"
#import "Shop.h"

#import "NSString+Addtion.h"
#import "AttributedLabel.h"
#import "BHBLabel.h"
#import "CLBCustomAlertView.h"
