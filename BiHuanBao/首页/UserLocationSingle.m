//
//  UserLocationSingle.m
//  ilpUser
//
//  Created by elongtian on 14-10-16.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "UserLocationSingle.h"

static UserLocationSingle * single;
@implementation UserLocationSingle
@synthesize locationStr;
@synthesize coor;
@synthesize city;
@synthesize streetName;
@synthesize detailName;

+ (UserLocationSingle *)shareSingle
{
    if(single == nil)
    {
        single = [[UserLocationSingle alloc]init];
    }
    return single;
}
@end
