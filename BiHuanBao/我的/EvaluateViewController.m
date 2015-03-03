//
//  EvaluateViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/14.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "EvaluateViewController.h"

@interface EvaluateViewController ()

@end

@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BackGround_Color;
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"发表评论";
    navBar.homebtn.hidden = YES;
    [self.view addSubview:navBar];
    
    keyboardheight = 216;
    
    currentCell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluateViewCell" owner:self options:nil] lastObject];
    [currentCell.commitBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchDown];
    currentCell.text_view.delegate = self;
    currentCell.star.rating = 5;
    if(_is_order)
    {
        currentCell.state.text = @"已签收";
    }
    else
    {
        currentCell.state.text = @"已使用";
    }
    
}

#pragma mark - 键盘高度
//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification

{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    keyboardheight = keyboardRect.size.height;
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        for (NSLayoutConstraint *constraint in self.mtableview.superview.constraints) {
                if(constraint.secondItem == self.mtableview)
                {
                    if (constraint.firstAttribute == NSLayoutAttributeBottom) {
                        constraint.constant = keyboardheight;
                    }

                }
        }
        [self.mtableview layoutIfNeeded];
    
    [UIView commitAnimations];
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
 
    for (NSLayoutConstraint *constraint in self.mtableview.superview.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeBottom) {
                constraint.constant = 10;
            }
        }
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
    
}

#pragma mark - UItextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.currenttextView = (ELTextView *)textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return currentCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 384;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (void)commit:(UIButton *)sender
{
    [self.indicator startAnimatingActivit];
    NSString * url = nil;
    if(_is_order)
    {
        url = [NSString stringWithFormat:@"%@%@&auto_id=%@&&frm[content_body]=%@&frm[review_id]=%@&frm[content_score]=%d&frm[content_type]=%@&ID=%@&PWD=%@",HTTP,EvaluateOrderUrl,_mitem.oderpro_id,[currentCell.text_view.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],_mitem.auto_id,(int)currentCell.star.rating,self.content_type,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@%@&auto_id=%@&&frm[content_body]=%@&frm[review_id]=%@&frm[content_score]=%d&frm[content_type]=%@&ID=%@&PWD=%@",HTTP,EvaluateQuanUrl,self.auto_id,[currentCell.text_view.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.review_id,(int)currentCell.star.rating,self.content_type,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    }
    
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            //评价成功,发送通知
            if(_is_order)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:EvaluateOrderNotification object:nil];
            }
            else
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:EvaluateQuanNotification object:nil];
            }
            
            [self performSelector:@selector(back:) withObject:nil afterDelay:1.0];
            
        }
        else
        {
            
        }
        
        [self.view makeToast:[dic objectForKey:@"msg"]];
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
        [self.indicator LoadSuccess];
    }];
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
