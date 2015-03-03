//
//  ELStarRatingView.m
//  ELStarRatingView
//
//  Created by madongkai on 14-11-03.
//  Copyright (c) 2014年 elongtian. All rights reserved.
//

#import "ELStarRatingView.h"


#define TotalScore 5.0
#define DefaultNumberOfStars 5

@interface ELStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation ELStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:DefaultNumberOfStars
            ];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"backgroundStar"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"foregroundStar"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        _numberOfStar = DefaultNumberOfStars;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"backgroundStar"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"foregroundStar"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (void)setRating:(float)rating
{
    _rating = rating;
    CGPoint pt = CGPointMake(rating/TotalScore*self.frame.size.width, 0);
    NSLog(@"%f",rating/TotalScore);
    [self changeStarForegroundViewWithPoint:pt];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak ELStarRatingView * weekSelf = self;
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:point];
     }
                    completion:^(BOOL finished)
     {
    
     }];
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        [view addSubview:imageView];
    }
    return view;
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }
    
    NSString * str = nil;
    float score ;
    if(self.isFraction)
    {
        
        str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
        score = [str floatValue];
    }
    else
    {
        str = [NSString stringWithFormat:@"%0.1f",p.x / self.frame.size.width];
        score = [str floatValue];
        int s = score*10;
        DLog(@"%d",s);
        if(s%2 == 0)
        {
            
        }
        else
        {
            score+=0.1;
        }
        DLog(@"+++%f",score);

    }
    p.x = score * self.frame.size.width;
    self.starForegroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)])
    {
        [self.delegate starRatingView:self score:score];
    }
}

@end