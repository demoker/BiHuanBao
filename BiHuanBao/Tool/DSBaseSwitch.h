//
//  DSBaseSwitch.h
//  FuTian
//
//  Created by 张贝贝 on 13-8-30.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSBaseSwitch : NSObject
+ (NSData*) base64Decode:(NSString *)string;

+ (NSString*) base64Encode:(NSData *)data;
@end
