//
//  JRNavgationBar.m
//  Mtest
//
//  Created by elongtian on 13-10-22.
//  Copyright (c) 2013年 elongtian. All rights reserved.
//

#import "JRNavgationBar.h"
#import "NSString+Addtion.h"
#define GETRESOURCEIMAGE(name,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]]


@implementation JRNavgationBar
@synthesize homebtn;
@synthesize backbtn;
@synthesize callbtn;
@synthesize bedbtn;
@synthesize sharebtn;
@synthesize setbtn;
@synthesize titleLabel;
@synthesize bg_imageView;
@synthesize delegate;
@synthesize done;
@synthesize title_bg_view;


- (id)initWithFrame:(CGRect)frame Option:(JRNAVGATIONTYPE)type{
    self = [super initWithFrame:frame];
    if (self) {
        
        bg_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT)];
        DLog(@"%d",NAVHEIGHT);
        bg_imageView.image = nil;
        bg_imageView.backgroundColor = UIColorFromRGB(0xff5000);
        bg_imageView.userInteractionEnabled = YES;

        [self addSubview:bg_imageView];
        DLog(@"%d,---%f",NAVHEIGHT,bg_imageView.frame.size.height);
        
        
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (IOS7?20:0), 200, 30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setTextColor:[UIColor whiteColor]];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.center = CGPointMake(self.frame.size.width/2, 44/2+(IOS7?25:5));
        titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleTap:)];
        [titleLabel addGestureRecognizer:tap];
        
        
        title_bg_view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xiala_down"]];
        title_bg_view.frame = CGRectMake(0, titleLabel.frame.origin.y, 20, 20);
        [self addSubview:title_bg_view];
        
        
        [titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew |NSKeyValueObservingOptionOld context:NULL];
        [self addSubview:titleLabel];
        
        backbtn = [JRNavButton buttonWithType:UIButtonTypeCustom];
        backbtn.frame = CGRectMake(6, IOS7?20:0, 44, 44);
        backbtn.center = CGPointMake(backbtn.center.x, (IOS7?20:0)+44/2);
        [backbtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        backbtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        backbtn.showsTouchWhenHighlighted = YES;
        
        [backbtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:backbtn];
        
        homebtn = [JRNavButton buttonWithType:UIButtonTypeCustom];
        homebtn.frame = CGRectMake(self.frame.size.width-44, IOS7?20:0, 44, 44);
        homebtn.center = CGPointMake(homebtn.center.x, (IOS7?20:0)+44/2);
        homebtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
//        [homebtn setImage:GETRESOURCEIMAGE(@"home", @"png") forState:UIControlStateNormal];
//        [homebtn setBackgroundImage:[UIImage imageNamed:@"filter_btn_bg"] forState:UIControlStateNormal];
        homebtn.showsTouchWhenHighlighted = YES;
        [homebtn addTarget:self action:@selector(home:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:homebtn];
        
//        callbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        callbtn.frame = CGRectMake(self.frame.size.width-88, isIos7System?20:0, 44, 44);
//        [callbtn setImage:GETRESOURCEIMAGE(@"call", @"png") forState:UIControlStateNormal];
//         [callbtn setTitle:@"电话" forState:UIControlStateNormal];
//        callbtn.showsTouchWhenHighlighted = YES;
//        [callbtn addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchDown];
//        [self addSubview:callbtn];
        
        bedbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bedbtn.frame = CGRectMake(self.frame.size.width-88,IOS7?30:10, 30, 30);
        [bedbtn setImage:GETRESOURCEIMAGE(@"bed", @"png") forState:UIControlStateNormal];
         [bedbtn setTitle:@"客房" forState:UIControlStateNormal];
        bedbtn.showsTouchWhenHighlighted = YES;
        [bedbtn addTarget:self action:@selector(bed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:bedbtn];
        
        sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebtn.frame = CGRectMake(self.frame.size.width-44, IOS7?28:8, 30, 30);
        [sharebtn setImage:GETRESOURCEIMAGE(@"share", @"png") forState:UIControlStateNormal];
         [sharebtn setTitle:@"分享" forState:UIControlStateNormal];
        sharebtn.showsTouchWhenHighlighted = YES;
        [sharebtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:sharebtn];
        
        setbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setbtn.frame = CGRectMake(self.frame.size.width-88,IOS7?30:10, 30, 30);
        setbtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [setbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [setbtn setImage:GETRESOURCEIMAGE(@"set", @"png") forState:UIControlStateNormal];
         [setbtn setTitle:@"设置" forState:UIControlStateNormal];
        setbtn.showsTouchWhenHighlighted = YES;
        [setbtn addTarget:self action:@selector(set:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:setbtn];
        
        
        
        done = [UIButton buttonWithType:UIButtonTypeCustom];
        done.frame = CGRectMake(self.frame.size.width-44,IOS7?30:10, 30, 30);
        done.titleLabel.font = [UIFont systemFontOfSize:12];
        [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [done setTitle:@"完成" forState:UIControlStateNormal];
        done.showsTouchWhenHighlighted = YES;
        [done addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:done];
        
//        JRNAVGATIONDEFAULTBAR,//默认，只显示back和主页
//        
//        JRNAVGATIONSHOWBAR,//展示界面 显示back，主页，床，call
//        
//        JRNAVGATIONLOGINBAR,//登录界面 只有back
//        
//        JRNAVGATIONSHOWHEADBAR,//展示首页，包含back，call，主页
//        
//        JRNAVGATIONACTIVITYBAR,//活动最终 back和分享
//        
//        JRNAVGATIONSETTINGBAR //个人信息界面，包含设置，back，主页
        
        switch (type) {
            case JRNAVGATIONDEFAULTBAR:
            {
                callbtn.hidden = YES;
                setbtn.hidden = YES;
                sharebtn.hidden = YES;
                bedbtn.hidden = YES;
                done.hidden = YES;
                title_bg_view.hidden = YES;
            }
                break;
            case JRNAVGATIONSHOWBAR:
            {
                setbtn.hidden = YES;
                sharebtn.hidden = YES;
                done.hidden = YES;
                title_bg_view.hidden = YES;
            }
                break;
            case JRNAVGATIONLOGINBAR:
            {
                callbtn.hidden = YES;
                setbtn.hidden = YES;
                sharebtn.hidden = YES;
                bedbtn.hidden = YES;
                homebtn.hidden = YES;
                done.hidden = YES;
                title_bg_view.hidden = YES;
            }
                break;
            case JRNAVGATIONSHOWHEADBAR:
            {
                setbtn.hidden = YES;
                sharebtn.hidden = YES;
                bedbtn.hidden = YES;
                done.hidden = YES;
                title_bg_view.hidden = YES;
                
            }
                break;
            case JRNAVGATIONACTIVITYBAR:
            {
                callbtn.hidden = YES;
                setbtn.hidden = YES;
                bedbtn.hidden = YES;
                homebtn.hidden = YES;
                done.hidden = YES;
                sharebtn.hidden = YES;
                title_bg_view.hidden = YES;
            }
                break;
            case JRNAVGATIONSETTINGBAR:
            {
                callbtn.hidden = YES;
                sharebtn.hidden = YES;
                bedbtn.hidden = YES;
                done.hidden = YES;
                title_bg_view.hidden = NO;
            }
                break;
            case JRNAVGATIONSETTING:
            {
                callbtn.hidden = YES;
                sharebtn.hidden = YES;
                bedbtn.hidden = YES;
                homebtn.hidden = YES;
                done.hidden = YES;
                title_bg_view.hidden = YES;
            }
                break;
            case JRNAVGATIONDONE:
            {
                callbtn.hidden = YES;
                setbtn.hidden = YES;
                sharebtn.hidden = YES;
                bedbtn.hidden = YES;
                homebtn.hidden = YES;
                title_bg_view.hidden = YES;
            }
                break;
            default:
                break;
        }

        typpe = type;
        //添加下滑手势
        UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipetoDown:)];
        swipe.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipe];
        
    }
    return self;
}
- (void)dealloc
{
////    self.title_bg_view = nil;
    [titleLabel removeObserver:self forKeyPath:@"text" context:nil];
//    self.bg_imageView = nil;
//    self.titleLabel = nil;
//    self.delegate = nil;
//    
//    [super dealloc];
}

- (void)back:(id)sender{
    if ([delegate respondsToSelector:@selector(back:)]) {
        [delegate back:sender];
    }
}
- (void)call:(id)sender
{
    if ([delegate respondsToSelector:@selector(call:)]) {
        [delegate call:sender];
    }
}
- (void)set:(id)sender
{
    if ([delegate respondsToSelector:@selector(set:)]) {
        [delegate set:sender];
    }
}
- (void)bed:(id)sender
{
    if ([delegate respondsToSelector:@selector(bed:)]) {
        [delegate bed:sender];
    }
}
- (void)home:(id)sender
{
    if ([delegate respondsToSelector:@selector(home:)]) {
        [delegate home:sender];
    }
}
- (void)share:(id)sender
{
    if ([delegate respondsToSelector:@selector(share:)]) {
        [delegate share:sender];
    }
}
- (void)done:(id)sender
{
    if([delegate respondsToSelector:@selector(done:)])
    {
        [delegate done:sender];
    }
}

- (void)titleTap:(id)sender
{
    if([delegate respondsToSelector:@selector(titleTap:)])
    {
        [delegate titleTap:sender];
    }
}

- (void)swipetoDown:(UISwipeGestureRecognizer *)swipe
{
    if([delegate respondsToSelector:@selector(swipetoDown:)])
    {
        [delegate swipetoDown:swipe];
    }
}
#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    begin = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    end = [touch locationInView:self];
    if(fabs(end.x-begin.x)<10&&end.y-begin.y>10)
    {
        if([delegate respondsToSelector:@selector(swipetoDown:)])
        {
            [delegate swipetoDown:nil];
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"text"])
    {
        self.titleLabel.numberOfLines = 0;
        CGSize s = CGSizeMake(SCREENWIDTH-120, 30);
        //sizeWithFont:self.titleLabel.font constrainedToSize:s lineBreakMode:NSLineBreakByWordWrapping];
        CGSize size = [self.titleLabel.text getcontentsizeWithfont:self.titleLabel.font constrainedtosize:s linemode:NSLineBreakByWordWrapping];
        self.titleLabel.frame  =CGRectMake(titleLabel.frame.origin.x, titleLabel.frame.origin.y, size.width, size.height);
        
        if(typpe != JRNAVGATIONSETTINGBAR)
        {
            self.titleLabel.center = CGPointMake(self.frame.size.width/2, self.titleLabel.center.y);
        }
        title_bg_view.frame = CGRectMake(titleLabel.frame.origin.x+titleLabel.frame.size.width, title_bg_view.frame.origin.y, title_bg_view.frame.size.width, title_bg_view.frame.size.height);
    }
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
