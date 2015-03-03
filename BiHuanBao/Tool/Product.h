//
//  Product.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-21.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "STDbObject.h"


@interface Product : STDbObject
@property (retain, nonatomic) NSString * auto_id;//某家产品id
@property (retain, nonatomic) NSString * product_id;//产品库id
@property (retain, nonatomic) NSString * content_name;
@property (retain, nonatomic) NSString * content_img;
@property (retain, nonatomic) NSString * content_price;
@property (retain, nonatomic) NSString * content_num;
@property (retain, nonatomic) NSString * member_id;
@property (retain, nonatomic) NSString * shop_name;
@property (retain, nonatomic) NSString * content_total;//小计
@property (assign, nonatomic) BOOL selected;//是否选择
@end


