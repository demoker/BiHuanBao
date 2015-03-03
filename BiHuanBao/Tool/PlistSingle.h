//
//  PlistSingle.h
//  ilpUser
//
//  Created by elongtian on 14-11-6.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistSingle : NSObject
+ (PlistSingle *)share;
- (void)write:(NSString *)name data:(id)data;
- (id)read:(NSString *)name;
@end
