//
//  UserLocationSingle.h
//  ilpUser
//
//  Created by elongtian on 14-10-16.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BMapKit.h"
@interface UserLocationSingle : NSObject
@property (retain, nonatomic) NSString * locationStr;
@property (assign, nonatomic) CLLocationCoordinate2D coor;
@property (retain, nonatomic) NSString * city;
@property (retain, nonatomic) NSString * streetName;
@property (retain, nonatomic) NSString * detailName;
+ (UserLocationSingle *)shareSingle;
@end
