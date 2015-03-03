//
//  ShoppingCartViewController.m
//  BuyBuyring
//
//  Created by 易龙天 on 13-12-3.
//  Copyright (c) 2013年 易龙天. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "ShoppingViewCell.h"
#import "ShopCarHeadCell.h"

#import "BBRShopView.h"
#import "Shop.h"
#import "ShopCarLastCell.h"
#import "BaoPaymentController.h"
@interface ShoppingCartViewController ()

@end

@implementation ShoppingCartViewController
@synthesize ShoppTableView;
@synthesize TotelmoneyLabel;
@synthesize SettlementBtn;
@synthesize SettlementView;
@synthesize dataArr;
@synthesize selectedIndexPath;
@synthesize editSelectIndexPath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    self.dataArr = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self againGetData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appearTabbar" object:nil];
    [self.indicator setIndicatorType:ActivityIndicatorDefault];
}

//- (void)download
//{
//    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&num=%@&ID=%@&PWD=%@",HTTP,ShopCarCommitUrl,self.str_auto_id,self.str_num,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
//    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary * dic = (NSDictionary *)responseObject;
//        if([[dic objectForKey:@"status"] integerValue] == 0&&[dic objectForKey:@"msg"] != nil)
//        {
//            [self.view makeToast:[dic objectForKey:@"msg"]];
//            [self.indicator abnormalButtonShow:[UIImage imageNamed:@"no_data"] text:@"库存不足！"];
//        }
//        else
//        {
//            NSDictionary * dict = [dic objectForKey:@"data"];
//            
//            for(NSString * str in [dict allKeys])
//            {
//                NSMutableArray * arr = [[NSMutableArray alloc]init];
//                for(NSDictionary * d in [dict objectForKey:str])
//                {
//                    ProductListItem * product = [[ProductListItem alloc]init];
//                    product.auto_id = [d objectForKey:@"c_pid"];
//                    product.corp_name = [d objectForKey:@"c_corpname"];
//                    product.content_name = [d objectForKey:@"c_pname"];
//                    product.content_preprice = [d objectForKey:@"c_ppay"];
//                    product.content_num = [d objectForKey:@"c_num"];
//                    product.sub_title = [d objectForKey:@"c_stitle"];
//                    product.content_img = [d objectForKey:@"content_img"];
//                    product.totalpay = [d objectForKey:@"totalpay"];
//                    
//                    [arr addObject:product];
//                }
//                if(dataArr == nil)
//                {
//                    dataArr = [[NSMutableArray alloc]init];
//                }
//                [dataArr addObject:arr];
//            }
//            self.totalMoney = [dic objectForKey:@"totalspay"];
//            self.totalNum = [dic objectForKey:@"totalsnums"];
//            
//            if([dataArr count] == 0)
//            {
//                if(self.indicator == nil)
//                {
//                    self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT-49) LabelText:@"没有数据" withdelegate:self withType:ActivityIndicatorDefault andAction:nil];
//                    [self.view addSubview:self.indicator];
//                    self.indicator.userInteractionEnabled = YES;
//                }
//                [self.indicator startAnimatingActivit];
//                [self.indicator abnormalButtonShow:[UIImage imageNamed:@"kong_shop"] text:nil];
//            }
//            else
//            {
//                [self.indicator LoadSuccess];
//                [ShoppTableView reloadData];
//            }
//            
//           
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self.indicator LoadFailed];
//        [self.view makeToast:NO_NET];
//    }];
//}

- (void)viewDidLayoutSubviews
{
    [self.view setBackgroundColor:BackGround_Color];
    self.ShoppTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    navTitleView = [[JRNavgationBar alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];

    [navTitleView.homebtn setImage:[UIImage imageNamed:@"shopcar_edit.png"] forState:UIControlStateNormal];
    navTitleView.backbtn.hidden = YES;
    [navTitleView.homebtn setTitle:nil forState:UIControlStateNormal];
    navTitleView.titleLabel.text = @"购物车";
    navTitleView.delegate = self;
    [self.view addSubview:navTitleView];
    
    isedit = NO;
    
    SettlementView.frame = CGRectMake(0, SCREENHEIGHT-(IOS7?44:64), SCREENWIDTH, SettlementView.frame.size.height);
    [SettlementBtn addTarget:self action:@selector(settlementACtion:) forControlEvents:UIControlEventTouchDown];
    
    ShoppTableView.backgroundColor = [UIColor clearColor];
    [ShoppTableView setOpaque:YES];
    
    
    [SettlementBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -SettlementBtn.imageView.frame.size.width, 0, SettlementBtn.imageView.frame.size.width)];
    
    [SettlementBtn setImageEdgeInsets:UIEdgeInsetsMake(0, SettlementBtn.titleLabel.bounds.size.width, 0, -SettlementBtn.titleLabel.bounds.size.width)];
    
    [_continueShop addTarget:self action:@selector(continueShopAction:) forControlEvents:UIControlEventTouchDown];
    
    if(self.indicator == nil)
    {
        self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT-49) LabelText:LOADING withdelegate:nil withType:ActivityIndicatorDefault andAction:nil];
        [self.indicator startAnimatingActivit];
        [self.view addSubview:self.indicator];
    }
    else
    {
        [self.view bringSubviewToFront:self.indicator];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:self.indicator];
}
#pragma mark - 去结算
- (void)continueShopAction:(UIButton *)sender
{
    //继续购物
}
- (void)settlementACtion:(UIButton *)sender{
    
    self.str_auto_id = nil;
    self.str_num = nil;
    money = 0;
    
    if(dataArr == nil)
    {
        dataArr = [[NSMutableArray alloc]init];
    }
    else
    {
        [dataArr removeAllObjects];
    }
    if(self.str_auto_id == nil)
    {
        self.str_auto_id = [[NSMutableString alloc]init];
        self.str_num = [[NSMutableString alloc]init];
    }
    
    NSArray * merchants = [Shop allDbObjects];
    for(Shop * shop in merchants)
    {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        [dic setValue:shop.member_id forKey:@"member_id"];
        [dic setValue:shop.shop_name forKey:@"shop_name"];
        for(Product * p in [Product dbObjectsWhere:[NSString stringWithFormat:@"member_id=%@",shop.member_id] orderby:@"member_id"])
        {
            DLog(@"%@",p);
            if(self.str_auto_id.length == 0)
            {
                self.str_auto_id = [NSMutableString stringWithString:p.auto_id];
                self.str_num = [NSMutableString stringWithString:p.content_num];
            }
            else
            {
                [self.str_auto_id appendFormat:@",%@",p.auto_id];
                [self.str_num appendFormat:@",%@",p.content_num];
            }
        }
    }
    if(self.str_auto_id.length == 0)
    {
        if(self.indicator == nil)
        {
            self.indicator = [[ActivityIndicator alloc] initWithFrame: CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT-49) LabelText:@"没有数据" withdelegate:self withType:ActivityIndicatorDefault andAction:nil];
            [self.view addSubview:self.indicator];
            self.indicator.userInteractionEnabled = YES;
        }
        [self.indicator startAnimatingActivit];
        [self.indicator setIndicatorType:ActivityIndicatorDefault];
        [self.indicator abnormalButtonShow:[UIImage imageNamed:@"kong_shop"] text:nil];
    }
    else
    {
        if([[UserLoginInfoManager loginmanager] state])
        {
            BaoPaymentController * payemnt = [[BaoPaymentController alloc]initWithNibName:@"BaoPaymentController" bundle:nil];
            payemnt.str_auto_id = self.str_auto_id;
            payemnt.str_num = self.str_num;
            [self.navigationController pushViewController:payemnt animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
        }
        else
        {
            [self login:YES];
        }
    }
    
//    if([[UserLoginInfoManager loginmanager] state]||[[[NSUserDefaults standardUserDefaults] objectForKey:@"direct_purchase"] boolValue])
//    {
//        PaymentViewController  * paymentView = [[PaymentViewController alloc] initWithNibName:@"PaymentViewController" bundle:nil];
//        
//        [self.navigationController pushViewController:paymentView animated:YES];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
//    }
//    else
//    {
//        [self login:YES];
//    }
    

}

#pragma mark - UITextFieldDelegate


#pragma  mark - 登录

- (void)login:(BOOL)sender
{
    LoginController * login = [[LoginController alloc]init];
    login.islogin = YES;
    login.from_pay = YES;
    login.delegate = self;
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:login];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - LoginDelegate
- (void)loginfinished
{
    //
    [self settlementACtion:nil];
}
- (void)touchDirectPurchase:(BOOL)direct
{
    [self settlementACtion:nil];
}
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)home:(id)sender{
//    isedit = !isedit;
//    
//    if(isedit)
//    {
//        [self.view makeToast:@"向左滑动可以删除商品"];
//    }
//    [dataArr removeAllObjects];
//    NSArray * merchants = [Shop allDbObjects];
//    
//    for(Shop * shop in merchants)
//    {
//        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
//        [dic setValue:shop.member_id forKey:@"member_id"];
//        [dic setValue:shop.shop_name forKey:@"shop_name"];
//        NSMutableArray * arr = [[NSMutableArray alloc] init];
//        for(Product * p in [Product dbObjectsWhere:[NSString stringWithFormat:@"member_id=%@",shop.member_id] orderby:@"member_id"])
//        {
//            [arr addObject:p];
//        }
//        [dic setObject:arr forKey:@"products"];
//        [dataArr addObject:dic];
//    }
//    
//    [ShoppTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[dataArr objectAtIndex:section] objectForKey:@"products"] count]+2;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        if(indexPath.row == 0)
        {
            return 42;
        }
        else if (indexPath.row == [[[dataArr objectAtIndex:indexPath.section] objectForKey:@"products"] count]+1)
        {
            return 42;
        }
        else
        {
            return 90;
        }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0)
    {
        ShopCarHeadCell * cell = [ShoppTableView dequeueReusableCellWithIdentifier:@"ShopCarHeadCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopCarHeadCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.merchantName.text = [[dataArr objectAtIndex:indexPath.section] objectForKey:@"shop_name"];
        return cell;
    }
    else if (indexPath.row == [[[dataArr objectAtIndex:indexPath.section] objectForKey:@"products"] count]+1)
    {
        ShopCarLastCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCarLastCell"];
        if(cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShopCarLastCell" owner:self options:nil] lastObject];
        }
        cell.totalMoney.text = [[dataArr objectAtIndex:indexPath.section] objectForKey:@"xiaoji"];
        return cell;
    }
    else
    {
            ShoppingViewCell * cell = [ShoppTableView dequeueReusableCellWithIdentifier:@"ShoppingViewCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingViewCell" owner:self options:nil] lastObject];
                cell.userInteractionEnabled = YES;
                
                cell.numberTextField.delegate = self;
                
                [cell.addBtn addTarget:self action:@selector(addNAction:) forControlEvents:UIControlEventTouchDown];
                [cell.subBtn addTarget:self action:@selector(subAction:) forControlEvents:UIControlEventTouchDown];
                 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:cell.numberTextField];
                [cell.deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchDown];
            }
        cell.deleteBtn.tag = 100000*indexPath.section+indexPath.row;
        
        cell.numberTextField.tag = 3000*indexPath.section+indexPath.row;
        
        cell.addBtn.tag = 1000*indexPath.section+indexPath.row;
        cell.subBtn.tag = 2000*indexPath.section+indexPath.row;
       
        if(indexPath.row == [[[dataArr objectAtIndex:indexPath.section] objectForKey:@"products"] count])
        {
            cell.bottom_line.hidden = YES;
        }
        else
        {
            cell.bottom_line.hidden = NO;
        }
        Product * product = [[[dataArr objectAtIndex:indexPath.section]objectForKey:@"products"] objectAtIndex:indexPath.row-1];

            [cell.content_ImgV setImageWithURL:[NSURL URLWithString:product.content_img] placeholderImage:[UIImage imageNamed:@"no_phote"]];
            cell.content_name.text = product.content_name;
            cell.content_price.text = [NSString stringWithFormat:@"%@",product.content_price];
//            cell.content_total.text = [NSString stringWithFormat:@"¥%.2f",[product.totalpay floatValue]];
            cell.numberTextField.text = product.content_num;
            return cell;
    }
}

#pragma mark - 增加减数量
- (ShoppingViewCell *)getShopCell:(NSInteger)section and:(NSInteger)row
{
    ShoppingViewCell * cell = (ShoppingViewCell *)[ShoppTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
    return cell;
}
- (void)addNAction:(UIButton *)sender
{
    int section = sender.tag/1000;
    int row = sender.tag%1000;
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    ShoppingViewCell * cell = [self getShopCell:indexpath.section and:indexpath.row];
    int n = [cell.numberTextField.text integerValue];
    self.defaultNumber = cell.numberTextField.text ;
    [self validationAction:indexpath andN:++n];
}
- (void)validationAction:(NSIndexPath *)indexpath andN:(int)num
{
    Product * product = [[[dataArr objectAtIndex:indexpath.section] objectForKey:@"products"] objectAtIndex:indexpath.row-1];
     ShoppingViewCell * cell = [self getShopCell:indexpath.section and:indexpath.row];
    
    [self.indicator setIndicatorType:ActivityIndicatorLogin];
    [self.indicator startAnimatingActivit];
    
    NSString * url = [NSString stringWithFormat:@"%@%@&auto_id=%@&num=%d",HTTP,ShopCarEditUrl,product.auto_id,num];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;
        if([[dic objectForKey:@"status"] integerValue] == 1)
        {
            Product * pro = [[Product alloc]init];
            pro.content_num = product.content_num;
            pro.auto_id = product.auto_id;
            if([Product existDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id]])
            {
                Product * product2 = [[Product dbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id] orderby:nil] lastObject];
                product2.content_num = [NSString stringWithFormat:@"%d",num];
                [product2 updatetoDb];
            }
            else
            {
                [pro insertToDb];
            }
            
            cell.numberTextField.text = [NSString stringWithFormat:@"%d",num];
            [self againGetData];
        }
        else
        {
            [self.view makeToast:[dic objectForKey:@"msg"]];
            cell.numberTextField.text = self.defaultNumber;
        }
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadSuccess];
        [self.view makeToast:NO_NET];
    }];
}
- (void)subAction:(UIButton *)sender
{
    int section = sender.tag/2000;
    int row = sender.tag%2000;
    ShoppingViewCell * cell = [self getShopCell:section and:row];
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    int n = [cell.numberTextField.text integerValue];
    self.defaultNumber = cell.numberTextField.text ;
    if(n == 1)
    {
        
    }
    else
    {
        [self validationAction:indexpath andN:--n];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.row!=0)
    {
        if(indexPath.row%2==0)
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbar" object:nil];
        }
        
    }

}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return UITableViewCellEditingStyleNone;
    }
    else if (indexPath.row == [[[dataArr objectAtIndex:indexPath.section] objectForKey:@"products"] count]+1)
    {
        return UITableViewCellEditingStyleNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"您是否删除购物车中的商品?" leftButtonTitle:@"否" leftActionBlock:^(CLBCustomAlertView *view) {

        [view dismiss];
    } rightButtonTitle:@"是" rightActionBlock:^(CLBCustomAlertView *view) {
        Product * product = [[[dataArr objectAtIndex:indexPath.section] objectForKey:@"products"] objectAtIndex:indexPath.row-1];
        if( [Product removeDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id]])
        {
            if([Product dbObjectsWhere:[NSString stringWithFormat:@"member_id=%@",product.member_id] orderby:@"member_id"] == nil)
            {
                [Shop removeDbObjectsWhere:[NSString stringWithFormat:@"member_id=%@",product.member_id] ];
            }
        }
        
        [self againGetData];
        [view dismiss];
    }];
    [alertView show];
    
}


- (void)againGetData
{
    self.str_auto_id = nil;
    self.str_num = nil;
    money = 0;
    
    if(dataArr == nil)
    {
        dataArr = [[NSMutableArray alloc]init];
    }
    else
    {
        [dataArr removeAllObjects];
    }
    if(self.str_auto_id == nil)
    {
        self.str_auto_id = [[NSMutableString alloc]init];
        self.str_num = [[NSMutableString alloc]init];
    }
    
    NSArray * merchants = [Shop allDbObjects];
    
    if([merchants count] == 0||[[[UserLoginInfoManager loginmanager] isCorper] integerValue] == 2)
    {
        if(self.indicator == nil)
        {
            self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:@"没有数据" withdelegate:self withType:ActivityIndicatorDefault andAction:nil];
            [self.view addSubview:self.indicator];
            self.indicator.userInteractionEnabled = YES;
        }
        [self.indicator startAnimatingActivit];
        [self.indicator setIndicatorType:ActivityIndicatorDefault];
        [self.indicator abnormalButtonShow:[UIImage imageNamed:@"kong_shop"] text:nil];
        return;
    }

    float total = 0;
    int num = 0;
    for(Shop * shop in merchants)
    {
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        [dic setValue:shop.member_id forKey:@"member_id"];
        [dic setValue:shop.shop_name forKey:@"shop_name"];
        NSMutableArray * arr = [[NSMutableArray alloc]init];
        float xiaoji = 0;
        for(Product * p in [Product dbObjectsWhere:[NSString stringWithFormat:@"member_id=%@",shop.member_id] orderby:@"member_id"])
        {
            DLog(@"%@",p);
            if(self.str_auto_id.length == 0)
            {
                self.str_auto_id = [NSMutableString stringWithString:p.auto_id];
                self.str_num = [NSMutableString stringWithString:p.content_num];
            }
            else
            {
                [self.str_auto_id appendFormat:@",%@",p.auto_id];
                [self.str_num appendFormat:@",%@",p.content_num];
            }
            [arr addObject:p];
            xiaoji+=[p.content_price floatValue]*[p.content_num integerValue];
            num+=[p.content_num integerValue];
        }

        total+=xiaoji;
        [dic setObject:arr forKey:@"products"];
        [dic setObject:[NSString stringWithFormat:@"%.3f",xiaoji] forKey:@"xiaoji"];
        
        self.totalMoney = [NSString stringWithFormat:@"%0.3f",total];
        self.totalNum = [NSString stringWithFormat:@"%d",num];
        
        self.TotelmoneyLabel.text = self.totalMoney;
        self.numberLabel.text = self.totalNum;
        
        [dataArr addObject:dic];
    }
    
    [ShoppTableView reloadData];
    [self.indicator LoadSuccess];
    
//    if(self.str_auto_id.length == 0)
//    {
//        if(self.indicator == nil)
//        {
//            self.indicator = [[ActivityIndicator alloc] initWithFrame:CGRectMake(0, NAVHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVHEIGHT) LabelText:@"没有数据" withdelegate:self withType:ActivityIndicatorDefault andAction:nil];
//            [self.view addSubview:self.indicator];
//            self.indicator.userInteractionEnabled = YES;
//        }
//        [self.indicator startAnimatingActivit];
//        [self.indicator abnormalButtonShow:[UIImage imageNamed:@"kong_shop"] text:nil];
//    }
//    else
//    {
//        [self.indicator startAnimatingActivit];
//        [self download];
//    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.defaultNumber = textField.text;
}

#pragma mark - 输入框文字检测

- (void)textFieldChanged:(NSNotification *)noti {
    
    UITextField * textfield = noti.object;
        int section = [textfield tag]/3000;
        int row = [textfield tag]%3000;
        NSIndexPath * indexpath = [NSIndexPath indexPathForRow:row inSection:section];
    if(textfield.text.length == 0)
    {
        
    }
    else
    {
        [self validationAction:indexpath andN:[[textfield text] integerValue]];
    }
    
}


#pragma mark - 删除
- (void)delete:(UIButton *)btn
{
    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:btn.tag%100000 inSection:btn.tag/100000];
    Product * product = [[[dataArr objectAtIndex:indexpath.section] objectForKey:@"products"] objectAtIndex:indexpath.row-1];
    product.selected = 1;
    
    CLBCustomAlertView * alertView = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"您是否删除购物车中的商品?" leftButtonTitle:@"否" leftActionBlock:^(CLBCustomAlertView *view) {
        
        [view dismiss];
    } rightButtonTitle:@"是" rightActionBlock:^(CLBCustomAlertView *view) {
        if( [Product removeDbObjectsWhere:[NSString stringWithFormat:@"auto_id=%@",product.auto_id]])
        {
            if([Product dbObjectsWhere:[NSString stringWithFormat:@"member_id=%@",product.member_id] orderby:@"member_id"] == nil)
            {
                [Shop removeDbObjectsWhere:[NSString stringWithFormat:@"member_id=%@",product.member_id] ];
            }
        }
        
        [self againGetData];
        [view dismiss];
    }];
    [alertView show];

}
#pragma mark - 进入商户主界面
- (void)goMerchant:(UITapGestureRecognizer *)tap
{
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
