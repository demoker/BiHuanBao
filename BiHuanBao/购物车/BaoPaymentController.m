//
//  BaoPaymentController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/7.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaoPaymentController.h"
#import "BaoPaymentCell.h"
#import "BaoPaymentOperationCell.h"
#import "BaoAddressPaymentCell.h"
#import "STDbHandle.h"
#import "CLBCustomAlertView.h"
@interface BaoPaymentController ()

@end

@implementation BaoPaymentController


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
//    _mtableview.frame = CGRectMake(10.0f, _mtableview.frame.origin.y, _mtableview.frame.size.width, SCREENHEIGHT-NAVHEIGHT-10-keyboardheight);
    
    for (NSLayoutConstraint *constraint in self.mtableview.superview.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = keyboardheight;
        }
    }
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}


//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification

{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
//    _mtableview.frame = CGRectMake(10, _mtableview.frame.origin.y, _mtableview.frame.size.width, SCREENHEIGHT-NAVHEIGHT-10);
    for (NSLayoutConstraint *constraint in self.mtableview.superview.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeBottom) {
            constraint.constant = 49;
        }
    }
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    navTitleView = [[JRNavgationBar alloc] initWithFrame:CGRectMake(0, 0, 320, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    
    [navTitleView.homebtn setHidden:YES];
    navTitleView.titleLabel.text = @"购物车";
    navTitleView.delegate = self;
    [self.view addSubview:navTitleView];
    
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = BackGround_Color;
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorLogin andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];
    [self download];
}
- (void)download
{
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&num=%@&ID=%@&PWD=%@",HTTP,ShopCarCommitUrl,self.str_auto_id,self.str_num,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        
        self.totalMoney = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalspay"]];
        self.yu_e = [NSString stringWithFormat:@"%@",[dic objectForKey:@"myaccount"]];
        self.username = OBJC([[dic objectForKey:@"mem"] objectForKey:@"m_user"]);
        self.contact = OBJC([[dic objectForKey:@"mem"] objectForKey:@"content_contact"]);
        self.tel = OBJC([[dic objectForKey:@"mem"] objectForKey:@"content_linkname"]);
        self.address = OBJC([[dic objectForKey:@"mem"] objectForKey:@"content_address"]);
        [self.indicator LoadSuccess];
        [_mtableview reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3)
    {
        BaoPaymentOperationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoPaymentOperationCell" owner:self options:nil] lastObject];
            [cell.cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchDown];
            [cell.gopayBtn addTarget:self action:@selector(gopayAction:) forControlEvents:UIControlEventTouchDown];
        }
        return cell;
    }
    else if(indexPath.row == 2)
    {
        BaoAddressPaymentCell * cell = [_mtableview dequeueReusableCellWithIdentifier:@"BaoAddressPaymentCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoAddressPaymentCell" owner:self options:nil] lastObject];
        }
        cell.contact.text = self.contact;
        cell.tel.text = self.tel;
        cell.address.text = self.address;
        return cell;
    }
    else
    {
        BaoPaymentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BaoPaymentCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"BaoPaymentCell" owner:self options:nil] lastObject];
        }
        if(indexPath.row == 0)
        {
            cell.orderLabel.hidden = YES;
            cell.totalMoney.text = self.totalMoney;
            cell.tagLabel.text = @"订单金额:";
        }
        else
        {
            cell.orderLabel.hidden = NO;
            cell.orderLabel.text = self.username;
            cell.totalMoney.text = self.yu_e;
            cell.tagLabel.text = @"账户余额:";
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.row == 3)
    {
        return 60;
    }
    else if (indexPath.row == 2)
    {
        return 150;
    }
    else
    {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}



#pragma mark - 操作事件
- (void)gopayAction:(UIButton *)sender
{
    BaoAddressPaymentCell * cell  = (BaoAddressPaymentCell *)[_mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if([cell.contact.text length] == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的联系人姓名" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    else if([cell.tel.text length] == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    else if([cell.address.text length] == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入正确的收货地址" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
        return;
    }
    NSLog(@"联系人%@",cell.contact.text);
    NSLog(@"手机%@",cell.tel.text);
    //确认支付
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&num=%@&ID=%@&PWD=%@&frm[content_linkname]=%@&frm[content_mobile]=%@&frm[content_address]=%@",HTTP,ShopCarCommitOrderUrl,self.str_auto_id,self.str_num,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd],[cell.contact.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],cell.tel.text,[cell.address.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            CLBCustomAlertView * alert = [[CLBCustomAlertView alloc]initWithTitle:@"支付成功" message:[dic objectForKey:@"msg"] leftButtonTitle:@"返回继续团购" leftActionBlock:^(CLBCustomAlertView *view) {
                [self back:nil];
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            alert.titleLabel.textColor = UIColorFromRGB(0x58b76a);
            alert.messageLabel.textColor = UIColorFromRGB(0x919191);
            [alert show];

            
            [STDbHandle removeDbTable:[Shop class]];
            [STDbHandle removeDbTable:[Product class]];
        }
        else
        {
            [self.view makeToast:[dic objectForKey:@"msg"]];

        }
        
        
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:NO_NET];
         [self.indicator LoadSuccess];
    }];
}
- (void)cancelAction:(UIButton *)sender
{
    [self back:nil];
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
