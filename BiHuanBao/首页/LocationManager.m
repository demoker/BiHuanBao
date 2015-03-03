//
//
//  LocationManager.m
//  BuyBuyring
//
//  Created by elongtian on 14-1-13.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "LocationManager.h"

#import "CLLocation+YCLocation.h"
//static LocationManager * locationManager = nil;

@implementation LocationManager
@synthesize checkinLocation;
@synthesize locationManager;
- ( void)dealloc
{
    
}
- (id)init
{
    if(self = [super init])
    {
        
    }
    return self;
}
- (void)startUpdates

{
    isfirst = YES;
    // Create the location manager if this object does not
    
    // already have one.
    
    if (nil == locationManager)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        // Set a movement threshold for new events
        locationManager.distanceFilter = 10;
    }
    
    [locationManager startUpdatingLocation];
    
    NSLog(@"%@",locationManager);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        casekCLAuthorizationStatusNotDetermined:
            if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [locationManager requestAlwaysAuthorization];
            }
            break;
        default:
            break;
            
            
    } 
}

//当设备无法定位当前我位置时候调用此方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorType = (error.code == kCLErrorDenied)?@"定位失败" : @"网络连接失败";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有获取到您的地理位置" message:errorType delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

// Delegate method from the CLLocationManagerDelegate protocol.

- (void)locationManager:(CLLocationManager *)manager

    didUpdateToLocation:(CLLocation *)newLocation

           fromLocation:(CLLocation *)oldLocation

{

      CLLocation*  newl = [[newLocation locationMarsFromEarth] locationBaiduFromMars];
        DLog(@"%f,%f",newl.coordinate.latitude,newl.coordinate.longitude);
        self.checkinLocation = newl;
        // [locationManager stopUpdatingHeading];//更新方向
        [locationManager stopUpdatingLocation];//更新位置
    
       if(userSearch == nil)
    {
        userSearch = [[BMKGeoCodeSearch alloc]init];
        userSearch.delegate = self;
    }
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption =[[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = newl.coordinate;
    BOOL flag = [userSearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading
{
    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    NSLog(@"%@",result.addressDetail.streetName);
    if (error == BMK_SEARCH_NO_ERROR) {
       
        
        if(isfirst)
        {
            [self.delegate performSelector:@selector(locationdidchecked:) withObject:result];
            isfirst = NO;
        }
        else
        {
            
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }

}

@end

