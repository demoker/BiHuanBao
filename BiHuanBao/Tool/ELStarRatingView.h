//
//  ELStarRatingView.h
//  ELStarRatingView
//
//  Created by madongkai on 14-11-03.
//  Copyright (c) 2014年 elongtian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ELStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(ELStarRatingView *)view score:(float)score;

@end

@interface ELStarRatingView : UIView

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;
@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;
@property (nonatomic, assign) float rating;//初始分值
@property (nonatomic, assign) BOOL isFraction;//是否支持分数
@end
