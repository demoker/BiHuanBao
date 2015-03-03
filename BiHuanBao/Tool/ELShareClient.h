//
//  ELShareClient.h
//  ilpUser
//
//  Created by elongtian on 14-6-30.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "AppDelegate.h"
typedef void(^ShareButtonClickedCompleted)(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end);
@interface ELShareClient : NSObject
{
    
}
@property (copy, nonatomic) ShareButtonClickedCompleted sharebtnClicked;
@property (retain, nonatomic) AppDelegate * appdelegate;
- (void)share:(NSDictionary *)dic;
@end
