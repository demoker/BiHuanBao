//
//  BaseViewController.m
//  BuyBuyring
//
//  Created by elongtian on 14-1-7.
//  Copyright (c) 2014年 易龙天. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize is_menu;
@synthesize indicator;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //增加监听，当键盘出现或改变时收出消息
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillShow:)
         
                                                     name:UIKeyboardWillShowNotification
         
                                                   object:nil];
        
        
        
        //增加监听，当键退出时收出消息
        
        [[NSNotificationCenter defaultCenter] addObserver:self
         
                                                 selector:@selector(keyboardWillHide:)
         
                                                     name:UIKeyboardWillHideNotification
         
                                                   object:nil];
        
    }
    return self;
}

#pragma mark - 键盘高度
//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification

{
    
    //获取键盘的高度

}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    if (IOS7) { // 判断是否是IOS7
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
	// Do any additional setup after loading the view.
}



#pragma mark - jrbardelegate
- (void)back:(id)sender
{}
- (void)share:(id)sender
{}
- (void)call:(id)sender
{
    NSLog(@"拨打电话");
}
- (void)set:(id)sender
{}
- (void)home:(id)sender
{}
- (void)bed:(id)sender
{}
- (void)titleTap:(id)sender
{
    
}


#pragma mark - 返回菜单
- (void)sendLoadSucessNotation
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%d",[[UserLoginInfoManager loginmanager] state]] forKey:@"login_state"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myNotificationName" object:self userInfo:dic];
}


//- (void)dealloc
//{
//    self.indicator = nil;
//    [super dealloc];
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
