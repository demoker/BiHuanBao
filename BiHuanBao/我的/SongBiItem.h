//
//  SongBiItem.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/24.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongBiItem : NSObject
@property (retain, nonatomic) NSString * auto_id;//预约表示
@property (retain, nonatomic) NSString * content_status;//是否接收
@property (retain, nonatomic) NSString * content_num;//预定金额
@property (retain, nonatomic) NSString * true_num;//实际接收金额
@property (retain, nonatomic) NSString * corp_name;
@property (retain, nonatomic) NSString * corp_address;
@property (retain, nonatomic) NSString * corp_mobile;
@property (retain, nonatomic) NSString * corp_linkname;
@property (retain, nonatomic) NSString * content_name;//活动名称
@property (retain, nonatomic) NSString * content_stotal;//送出总额
@property (retain, nonatomic) NSString * true_price;//实际送出总额

@property (retain, nonatomic) NSString * book_price;//累计预约
@property (retain, nonatomic) NSString * content_activity;//是否活动中
@end
