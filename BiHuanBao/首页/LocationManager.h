//
//  LocationManager.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-13.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"
@protocol LocationManagerDelegate<NSObject>
- (void)locationdidchecked:(BMKReverseGeoCodeResult *)result;
@end
@interface LocationManager : NSObject<CLLocationManagerDelegate,BMKGeoCodeSearchDelegate>
{
    
    BMKGeoCodeSearch * userSearch;
    BOOL isfirst;
   
}
@property (retain, nonatomic) CLLocationManager * locationManager;;
@property (retain, nonatomic) CLLocation *checkinLocation;
@property (assign, nonatomic) id delegate;
- (void)startUpdates;
@end
