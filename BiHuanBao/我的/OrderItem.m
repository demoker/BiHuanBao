//
//  OrderItem.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/22.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem
- (id)init
{
    if(self = [super init])
    {
        self.pros = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
