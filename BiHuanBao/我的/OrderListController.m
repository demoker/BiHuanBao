//
//  OrderListController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/11.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "OrderListController.h"
#import "OrderListThreeProCell.h"
#import "OrderListOneProCell.h"
#import "BHBOrderDetailViewController.h"
@interface OrderListController ()

@end

@implementation OrderListController
@synthesize un_list;
@synthesize old_list;
@synthesize return_list;
@synthesize type;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiverNotification:(NSNotification *)noti
{
    if([noti.name isEqualToString:ReturnGoodsNotification])
    {
        [un_list refresh];
        [old_list refresh];
        [return_list refresh];
    }
    else if ([noti.name isEqualToString:DeliveryedNotification])
    {
        [un_list refresh];
        [old_list refresh];
        [return_list refresh];
    }
    else if ([noti.name isEqualToString:EvaluateOrderNotification])
    {
        [un_list refresh];
        [old_list refresh];
        [return_list refresh];
    }
    else if([noti.name isEqualToString:CancelOrderNotification])
    {
        [un_list refresh];
        [old_list refresh];
        [return_list refresh];
    }
    else if ([noti.name isEqualToString:SureReceiptNotification])
    {
        [un_list refresh];
        [old_list refresh];
        [return_list refresh];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"我的订单";
    [self.view addSubview:navBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:ReturnGoodsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:DeliveryedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:EvaluateOrderNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:CancelOrderNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiverNotification:) name:SureReceiptNotification object:nil];
    
    type = @"0";
    
    self.view.backgroundColor = BackGround_Color;
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
    un_list = [[OrderList alloc] initWithNibName:@"OrderList" bundle:nil];
    un_list.task = @"unorder";
    un_list.app_com = self.app_com;
    un_list.delegate = self;
    un_list.view.frame = CGRectMake(0, _operationview.frame.size.height+_operationview.frame.origin.y, SCREENWIDTH, SCREENHEIGHT-(_operationview.frame.size.height+_operationview.frame.origin.y));
    
    un_list.mtableview.frame = CGRectMake(10, 0, SCREENWIDTH-20, SCREENHEIGHT-(_operationview.frame.size.height+_operationview.frame.origin.y));
    un_list.indicator = [[ActivityIndicator alloc] initWithFrame:un_list.view.bounds LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
    [un_list.indicator startAnimatingActivit];
    [un_list refresh];
    [un_list.view addSubview:un_list.indicator];
    un_list.view.hidden = NO;
    [self.view addSubview:un_list.view];
    
    old_list = [[OrderList alloc]initWithNibName:@"OrderList" bundle:nil];
    old_list.task = @"oldorder";
    old_list.app_com = self.app_com;
    old_list.delegate = self;
    old_list.view.frame = CGRectMake(0, _operationview.frame.size.height+_operationview.frame.origin.y, SCREENWIDTH, SCREENHEIGHT-(_operationview.frame.size.height+_operationview.frame.origin.y));
    old_list.mtableview.frame = CGRectMake(10, 0, SCREENWIDTH-20, SCREENHEIGHT-(_operationview.frame.size.height+_operationview.frame.origin.y));
    old_list.indicator = [[ActivityIndicator alloc] initWithFrame:un_list.view.bounds LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
    [old_list.indicator startAnimatingActivit];
    [old_list refresh];
    [old_list.view addSubview:old_list.indicator];
    old_list.view.hidden = YES;
    [self.view addSubview:old_list.view];
    
    return_list = [[ReturnGoodsList alloc]initWithNibName:@"ReturnGoodsList" bundle:nil];
    return_list.task = @"returnorder";
    return_list.app_com = self.app_com;
    return_list.delegate = self;
    return_list.view.frame = CGRectMake(0, _operationview.frame.size.height+_operationview.frame.origin.y, SCREENWIDTH, SCREENHEIGHT-(_operationview.frame.size.height+_operationview.frame.origin.y));
    return_list.mtableview.frame = CGRectMake(10, 0, SCREENWIDTH-20, SCREENHEIGHT-(_operationview.frame.size.height+_operationview.frame.origin.y));
    return_list.indicator = [[ActivityIndicator alloc] initWithFrame:un_list.view.bounds LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
    [return_list.indicator startAnimatingActivit];
    [return_list refresh];
    
    [return_list.view addSubview:return_list.indicator];
    return_list.view.hidden = YES;
    [self.view addSubview:return_list.view];
    
    [_doing_order_btn addTarget:self action:@selector(doingAction:) forControlEvents:UIControlEventTouchDown];
    [_did_order_btn addTarget:self action:@selector(didAction:) forControlEvents:UIControlEventTouchDown];
    [_return_order_btn addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchDown];
}
- (void)doingAction:(UIButton *)sender
{
    [_doing_order_btn setBackgroundColor:UIColorFromRGB(0xff602a)];
    [_did_order_btn setBackgroundColor:UIColorFromRGB(0xaaaaaa)];
    [_return_order_btn setBackgroundColor:UIColorFromRGB(0xaaaaaa)];
    self.type = @"0";
    un_list.view.hidden = NO;
    old_list.view.hidden = YES;
    return_list.view.hidden = YES;
}
- (void)didAction:(UIButton *)sender
{
//    [_doing_order_btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_did_order_btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//    [_return_order_btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
     [_doing_order_btn setBackgroundColor:UIColorFromRGB(0xaaaaaa)];
     [_did_order_btn setBackgroundColor:UIColorFromRGB(0xff602a)];
     [_return_order_btn setBackgroundColor:UIColorFromRGB(0xaaaaaa)];
    self.type = @"1";
    un_list.view.hidden = YES;
    old_list.view.hidden = NO;
    return_list.view.hidden = YES;
}
- (void)returnAction:(UIButton *)sender
{
    [_doing_order_btn setBackgroundColor:UIColorFromRGB(0xaaaaaa)];
    [_did_order_btn setBackgroundColor:UIColorFromRGB(0xaaaaaa)];
    [_return_order_btn setBackgroundColor:UIColorFromRGB(0xff602a)];
    self.type = @"2";
    un_list.view.hidden = YES;
    old_list.view.hidden = YES;
    return_list.view.hidden = NO;
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
