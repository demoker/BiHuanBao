//
//  IWantTuanViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/2.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "IWantTuanViewController.h"
#import "IWantTuanPromptViewCell.h"
#import "IWantTuanProViewCell.h"
#import "IWantTuanMonViewCell.h"
#import "CommitTableViewCell.h"
#import "CLBCustomAlertView.h"
@interface IWantTuanViewController ()

@end

@implementation IWantTuanViewController
@synthesize navBar;
@synthesize m_product;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = BackGround_Color;
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.titleLabel.text = @"我要团";
    [self.view addSubview:navBar];

    self.number = @"1";
    self.total = [NSString stringWithFormat:@"%.1f",[self.number integerValue]*[self.price floatValue]];
    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
    [self.indicator startAnimatingActivit];
    [self.view addSubview:self.indicator];
    _mtableview.opaque = NO;
    _mtableview.backgroundColor = [UIColor clearColor];
    
    m_product = [[ProductListItem alloc]init];
    
    [self download];
}

- (void)download
{
     [self.indicator startAnimatingActivit];
    NSString * url = [NSString stringWithFormat:@"%@%@&num=%@&auto_id=%@&ID=%@&PWD=%@",HTTP,IWantTuanUrl,self.number,self.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 0&&[dic objectForKey:@"msg"] != nil)
        {
            [self.view makeToast:[dic objectForKey:@"msg"]];
            [self.indicator abnormalButtonShow:[UIImage imageNamed:@"no_data"] text:@"库存不足！"];
        }
        else
        {
            m_product.corp_name = [[dic objectForKey:@"corp_name"] objectForKey:self.corp_id];
            m_product.content_preprice = [[[[dic objectForKey:@"data"] objectForKey:self.corp_id] lastObject] objectForKey:@"c_ppay"];
            m_product.sub_title = [[[[dic objectForKey:@"data"] objectForKey:self.corp_id] lastObject] objectForKey:@"c_stitle"];
            m_product.content_img = [[[[dic objectForKey:@"data"] objectForKey:self.corp_id] lastObject] objectForKey:@"content_img"];
            
            self.price = [[[[dic objectForKey:@"data"] objectForKey:self.corp_id] lastObject] objectForKey:@"c_ppay"];
            self.account = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"myaccount"] floatValue]];
            NSLog(@"%@",self.account);
            self.total = [NSString stringWithFormat:@"%@",[dic objectForKey:@"totalspay"]];
            self.content_user = [[dic objectForKey:@"mem"] objectForKey:@"m_user"];
            [self.indicator LoadSuccess];
            [_mtableview reloadData];
        }
       
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadFailed];
        [self.view makeToast:NO_NET];
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4*2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2==0)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    else
    {
        if(indexPath.row/2+1 == 1)
        {
            IWantTuanProViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IWantTuanProViewCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IWantTuanProViewCell" owner:self options:nil] lastObject];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.numberTextField.delegate = self;
                [cell.subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchDown];
                [cell.addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchDown];
            }
            cell.content_name.text = m_product.corp_name;
            cell.content_desc.text = m_product.sub_title;
            cell.content_price.text = m_product.content_preprice;
            [cell.content_img setImageWithURL:[NSURL URLWithString:m_product.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
            cell.numberTextField.text = self.number;
            
            if([m_product.content_isnew isEqualToString:@"1"])
            {
                //new_tag
                cell.img_tag.hidden = NO;
                [cell.img_tag setImage:[UIImage imageNamed:@"new_tag"]];
            }
            else if([m_product.content_isnew isEqualToString:@"2"])
            {
                cell.img_tag.hidden = NO;
                [cell.img_tag setImage:[UIImage imageNamed:@"hot_icon"]];
            }
            else
            {
                cell.img_tag.hidden = YES;
            }

            return cell;
        }
        else if(indexPath.row/2+1 == 2)
        {
            IWantTuanMonViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IWantTuanMonViewCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IWantTuanMonViewCell" owner:self options:nil] lastObject];
            }
            cell.account.text = self.account;
            cell.totalMoney.text = self.total;
            cell.username.text = self.content_user;
            return cell;
        }
        else if(indexPath.row/2+1 == 3)
        {
            IWantTuanPromptViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"IWantTuanPromptViewCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"IWantTuanPromptViewCell" owner:self options:nil] lastObject];
            }
            return cell;
        }
        else
        {
            CommitTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CommitTableViewCell"];
            if(cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:self options:nil] lastObject];
            }
            [cell.yuyueBtn setTitle:@"确认支付" forState:UIControlStateNormal];
            [cell.yuyueBtn addTarget:self action:@selector(yuyueAction:) forControlEvents:UIControlEventTouchDown];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
    {
        return 10;
    }
    else
    {
        if(indexPath.row/2+1 == 1)
        {
            return 100;
        }
        else if(indexPath.row/2+1 == 2)
        {
            return 107.f;
        }
        else if(indexPath.row/2+1 == 3)
        {
            return  78.f;
        }
        else
        {
            return 44.f;
        }
    }
}
#pragma mark - 确认支付
- (void)yuyueAction:(id)sender
{
    NSString * url = [NSString stringWithFormat:@"%@%@&num=%@&auto_id=%@&ID=%@&PWD=%@",HTTP,TuanCommitOrderUrl,self.number,self.auto_id,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            CLBCustomAlertView * alert = [[CLBCustomAlertView alloc]initWithTitle:@"支付成功" message:[dic objectForKey:@"msg"] leftButtonTitle:@"返回继续团购" leftActionBlock:^(CLBCustomAlertView *view) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            alert.titleLabel.textColor = UIColorFromRGB(0x58b76a);
            alert.messageLabel.textColor = UIColorFromRGB(0x919191);
            [alert show];
        }
        [self.view makeToast:[dic objectForKey:@"msg"]];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    }
#pragma mark - UITextFieldDelegate

#pragma mark -

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.number = [NSString stringWithFormat:@"%d",[[textField text] integerValue]];
    self.total = [NSString stringWithFormat:@"%.1f",[self.number integerValue]*[self.price floatValue]];
    [_mtableview reloadData];
}
- (IWantTuanProViewCell *)getTextFieldCell
{
    IWantTuanProViewCell * cell = (IWantTuanProViewCell *)[_mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    return cell;
}

#pragma mark - 增加减数量
- (void)subAction:(id)sender
{
    int num = [[[[self getTextFieldCell] numberTextField] text] integerValue];
    if(num==1)
    {
        return;
    }
    else
    {
        num--;
        [[[self getTextFieldCell] numberTextField] setText:[NSString stringWithFormat:@"%d",num]];
        self.number = [NSString stringWithFormat:@"%d",num];
        self.total = [NSString stringWithFormat:@"%.3f",[self.number integerValue]*[self.price floatValue]];
    }
    [_mtableview reloadData];
}

- (void)addAction:(id)sender
{
    int num = [[[[self getTextFieldCell] numberTextField] text] integerValue];
        num++;
        [[[self getTextFieldCell] numberTextField] setText:[NSString stringWithFormat:@"%d",num]];
        self.number = [NSString stringWithFormat:@"%d",num];
    self.total = [NSString stringWithFormat:@"%.3f",[self.number integerValue]*[self.price floatValue]];
    [_mtableview reloadData];
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
