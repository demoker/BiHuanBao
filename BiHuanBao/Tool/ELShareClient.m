//
//  ELShareClient.m
//  ilpUser
//
//  Created by elongtian on 14-6-30.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "ELShareClient.h"
@implementation ELShareClient
@synthesize appdelegate;
- (id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
    
}
- (void)share:(NSDictionary *)dic
{
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, ShareTypeTencentWeibo,ShareTypeQQSpace,ShareTypeSMS,ShareTypeCopy,ShareTypeWeixiSession,ShareTypeWeixiTimeline,ShareTypeQQ,ShareTypeWeixiFav, nil];
    
    //创建分享内容
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[dic objectForKey:@"image"] ofType:@"jpg"];
    id<ISSContent> publishContent = [ShareSDK content:[dic objectForKey:@"content"]
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:@"http://dj.7-hotel.com/file/upload/2014/06/21/1403868351.jpg"]
                                                title:[dic objectForKey:@"title"]
                                                  url:[dic objectForKey:@"url"]
                                          description:NSLocalizedString(@"TEXT_TEST_MSG", @"这是一条测试信息")
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
   // [container setIPadContainerWithView:nil arrowDirect:UIPopoverArrowDirectionUp];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    [authOptions setPowerByHidden:YES];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                    nil]];
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    DLog(@"%@",appdelegate.viewDelegate);
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                          oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                           qqButtonHidden:NO
                                                    wxSessionButtonHidden:NO
                                                   wxTimelineButtonHidden:NO
                                                     showKeyboardOnAppear:NO
                                                        shareViewDelegate:appdelegate.viewDelegate
                                                      friendsViewDelegate:appdelegate.viewDelegate
                                                    picViewerViewDelegate:nil]
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if(self.sharebtnClicked)
                                {
                                    self.sharebtnClicked(type, state, statusInfo, error, end);
                                }
                            }];
    
    
}
@end
