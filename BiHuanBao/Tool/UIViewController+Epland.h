//
//  UIViewController+Epland.h
//  BuyBuyring
//
//  Created by elongtian on 14-1-7.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Epland)
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
- (UIImage*)scaleFromImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
