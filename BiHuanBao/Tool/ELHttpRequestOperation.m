//
//  ELHttpRequestOperation.m
//  ElongtianRequest
//
//  Created by elongtian on 14-5-22.
//  Copyright (c) 2014年 elongtian. All rights reserved.
//

#import "ELHttpRequestOperation.h"

@implementation ELHttpRequestOperation
+ (instancetype)sharedClient {
    static ELHttpRequestOperation *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [ELHttpRequestOperation manager];
        [_sharedClient setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [[_sharedClient responseSerializer] setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        
    });
    
    return _sharedClient;
    
    UIImageView * img = nil;
    [img setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    
}
@end
