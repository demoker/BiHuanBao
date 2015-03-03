//
//  OrderItem.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/22.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItem : NSObject
@property (retain, nonatomic) NSString * auto_id;
@property (retain, nonatomic) NSString * content_sn;
@property (retain, nonatomic) NSString * content_status;
@property (retain, nonatomic) NSString * content_linkname;
@property (retain, nonatomic) NSString * content_address;
@property (retain, nonatomic) NSString * content_mobile;
@property (retain, nonatomic) NSString * is_pay;
@property (retain, nonatomic) NSString * is_status;
@property (retain, nonatomic) NSString * is_paystatus;
@property (retain, nonatomic) NSString * member_user;
@property (retain, nonatomic) NSString * content_total;
@property (retain, nonatomic) NSString * express_name;
@property (retain, nonatomic) NSString * express_no;
@property (retain, nonatomic) NSString * create_time;
@property (retain, nonatomic) NSString * corp_name;
@property (retain, nonatomic) NSString * corp_address;
@property (retain, nonatomic) NSString * corp_mobile;
@property (retain, nonatomic) NSString * corp_linkname;
@property (retain, nonatomic) NSMutableArray * pros;
@property (retain, nonatomic) NSString * content_num;//总数目
@end
