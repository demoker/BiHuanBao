//
//  PlistSingle.m
//  ilpUser
//
//  Created by elongtian on 14-11-6.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "PlistSingle.h"
static PlistSingle * instance = nil;
@implementation PlistSingle
+ (PlistSingle *)share
{
    if(instance == nil)
    {
        instance = [[PlistSingle alloc]init];
    }
    return instance;
}

- (void)write:(NSString *)name data:(id)data
{
   // [[NSUserDefaults standardUserDefaults] setObject:data forKey:name];
}
- (id)read:(NSString *)name
{
   return [[NSUserDefaults standardUserDefaults] objectForKey:name];
}
@end
