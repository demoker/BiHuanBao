//
//  ProductListItem.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/17.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductListItem : NSObject
@property (retain ,nonatomic) NSString * auto_id;
@property (retain, nonatomic) NSString * sub_title;
@property (retain, nonatomic) NSString * content_name;
@property (retain, nonatomic) NSString * content_img;
@property (retain, nonatomic) NSString * content_preprice;
@property (retain, nonatomic) NSString * content_sale;
@property (retain, nonatomic) NSString * content_score;
@property (retain, nonatomic) NSString * content_isnew;
@property (retain, nonatomic) NSString * corp_name;

@property (retain, nonatomic) NSString * content_num;
@property (retain, nonatomic) NSString * totalpay;

@end
