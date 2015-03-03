//
//  UserInfoViewController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import "VPImageCropperViewController.h"
@interface CorpInfoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>
{
    JRNavgationBar * navbar;
    BOOL is_edit;
    float scale;
}
@property (weak, nonatomic) IBOutlet UITableView *mtableview;
@property (retain, nonatomic) NSString * email;
@property (retain, nonatomic) NSString * username;
@property (retain, nonatomic) NSString * mobile;
@property (retain, nonatomic) NSString * address;
@property (retain, nonatomic) NSString * contact;
@property (retain, nonatomic) NSString * content_titleImg;
@property (retain, nonatomic) NSString * corp_name;
@property (retain, nonatomic) NSString * site;
@property (retain, nonatomic) NSString * content_tel;

@property (retain, nonatomic) UIImage * selfimage;
@end
