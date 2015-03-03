//
//  ShouBTCViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/26.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "ShouBTCViewController.h"
#import "QRCodeGenerator.h"
@interface ShouBTCViewController ()

@end

@implementation ShouBTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = BackGround_Color;
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"收款";
    [self.view addSubview:navBar];
    
    UIImage * image = [QRCodeGenerator qrImageForString:@"898dfe97hjhfkduthguetuertut" imageSize:_qrImgView.frame.size.width];
    [_qrImgView setImage:image];
    
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
