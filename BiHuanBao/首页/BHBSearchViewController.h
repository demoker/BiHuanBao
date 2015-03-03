//
//  BHBSearchViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/12.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "BaseViewController.h"

@interface BHBSearchViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,TableViewDelegate,UITextFieldDelegate>
{
    JRNavgationBar * navBar;
    int more;
}
@property (weak, nonatomic) IBOutlet ELTextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet TableView *searchtableView;
@property (retain, nonatomic) NSMutableArray * productArray;
@property (retain, nonatomic) NSString * keyword;
@end
