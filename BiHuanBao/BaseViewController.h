//
//  BaseViewController.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-7.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//
          
#import <UIKit/UIKit.h>
#import "ActivityIndicator.h"
#import "JRNavgationBar.h"
@interface BaseViewController : UIViewController<JRNavDelegate>
@property (assign, nonatomic) BOOL is_menu;
@property (retain, nonatomic) ActivityIndicator * indicator;
@property (retain, nonatomic) NSString * titleName;

- (void)trantionToMenu;
@end
