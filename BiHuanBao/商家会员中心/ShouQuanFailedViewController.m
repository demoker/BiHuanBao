//
//  ShouQuanSuccessViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/2.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "ShouQuanFailedViewController.h"

@interface ShouQuanFailedViewController ()

@end

@implementation ShouQuanFailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.backgroundColor = [UIColor clearColor];
    navBar.titleLabel.text = @"收券";
    navBar.homebtn.hidden = YES;
    [self.view addSubview:navBar];
    
    [_cancel_btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    [_sure_btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
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
