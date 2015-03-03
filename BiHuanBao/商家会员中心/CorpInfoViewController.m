//
//  UserInfoViewController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/15.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "CorpInfoViewController.h"
#import "CorpInfoTableViewCell.h"
#import "FileUtil.h"
#import "UIImage+Expland.h"
#define kPhotoName              @"content_img.png"
#define kImageCachePath         @"imagecache"
#define ORIGINAL_MAX_WIDTH 640.0f
@interface CorpInfoViewController ()

@end

@implementation CorpInfoViewController


- (void)keyboardWillShow:(NSNotification *)aNotification

{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    
    float keyboardheight = keyboardRect.size.height;
    
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
            constraint.constant = 0;
        }
    }
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    navbar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navbar.titleLabel.text = @"账户信息" ;
    [navbar.homebtn setHidden:YES];
    navbar.delegate = self;
    
    is_edit = NO;
    scale = 1;
    [self.view addSubview:navbar];
    [self download];
}

- (void)download
{
    NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@",HTTP,UserInfoUrl,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd]];
    [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary *)responseObject;

        self.email = OBJC([dic objectForKey:@"content_email"]);
        self.username = OBJC([dic objectForKey:@"content_user"]);
        self.mobile = OBJC([dic objectForKey:@"content_mobile"]);
        self.address = OBJC([dic objectForKey:@"content_address"]);
        self.contact = OBJC([dic objectForKey:@"content_linkname"]);
        self.content_titleImg = OBJC([dic objectForKey:@"content_face"]);
        
        self.corp_name = OBJC([dic objectForKey:@"content_name"]);
        self.site = OBJC([dic objectForKey:@"content_wz"]);
        self.content_tel = OBJC([dic objectForKey:@"content_contact"]);
        
        [_mtableview reloadData];
        [self.indicator LoadSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.indicator LoadFailed];
        [self.view makeToast:NO_NET];
    }];
}
#pragma mark - UItableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CorpInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CorpInfoTableViewCell"];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CorpInfoTableViewCell" owner:self options:nil] lastObject];
        cell.email.delegate = self;
        cell.corpname.delegate = self;
        cell.mobile.delegate = self;
        cell.address.delegate = self;
        cell.contact.delegate = self;
        cell.content_tel.delegate = self;
        cell.site.delegate = self;
        [cell.commit addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchDown];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(settitleImage:)];
        cell.content_titleImg.userInteractionEnabled = YES;
        [cell.content_titleImg addGestureRecognizer:tap];
    }
    if(is_edit)
    {
        [cell.commit setTitle:@"提交" forState:UIControlStateNormal];
//        cell.email.background = [UIImage imageNamed:@"login_input.png"];
//        cell.mobile.background = [UIImage imageNamed:@"login_input.png"];
        cell.textview_bg.image = [UIImage imageNamed:@"login_input.png"];
        cell.contact.background = [UIImage imageNamed:@"login_input.png"];
        
        cell.corpname.background = [UIImage imageNamed:@"login_input.png"];
        cell.site.background = [UIImage imageNamed:@"login_input.png"];
        cell.content_tel.background = [UIImage imageNamed:@"login_input.png"];
        
//        cell.email.userInteractionEnabled = YES;
//        cell.mobile.userInteractionEnabled = YES;
        cell.address.userInteractionEnabled = YES;
        cell.contact.userInteractionEnabled = YES;
        cell.content_titleImg.userInteractionEnabled = YES;
        cell.corpname.userInteractionEnabled = YES;
        cell.site.userInteractionEnabled = YES;
        cell.content_tel.userInteractionEnabled = YES;
    }
    else
    {
         [cell.commit setTitle:@"编辑" forState:UIControlStateNormal];
        cell.email.background = nil;
        cell.mobile.background = nil;
        cell.textview_bg.image = nil;
        cell.contact.background = nil;
        cell.corpname.background = nil;
        cell.site.background = nil;
        cell.content_tel.background = nil;
        
        cell.email.userInteractionEnabled = NO;
        cell.mobile.userInteractionEnabled = NO;
        cell.address.userInteractionEnabled = NO;
        cell.contact.userInteractionEnabled = NO;
        cell.content_titleImg.userInteractionEnabled = NO;
        cell.corpname.userInteractionEnabled = NO;
        cell.site.userInteractionEnabled = NO;
        cell.content_tel.userInteractionEnabled = NO;
    }
    cell.email.text = self.email;
    cell.username.text = self.username;
    cell.mobile.text = self.mobile;
    cell.address.text = self.address;
    cell.contact.text = self.contact;
    cell.corpname.text = self.corp_name;
    cell.site.text = self.site;
    cell.content_tel.text = self.content_tel;
    [cell.content_titleImg setImageWithURL:[NSURL URLWithString:self.content_titleImg] placeholderImage:[UIImage imageNamed:@"no_phote"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 559;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFiledDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag == 100)
    {
        self.corp_name = textField.text;
    }
    else if (textField.tag == 101)
    {
        self.email = textField.text;
    }
    else if (textField.tag == 102)
    {
        self.mobile = textField.text;
    }
    else if(textField.tag == 103)
    {
        self.contact = textField.text;
    }
    else if(textField.tag == 104)
    {
        self.content_tel = textField.text;
    }
    else if(textField.tag == 105)
    {
        self.site = textField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.address = textView.text;
}

- (void)commitAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    if(is_edit)
    {
        [self.indicator startAnimatingActivit];
        UIImage * modify_image = [UIImage fixOrientation:self.selfimage];
        [self saveImage:modify_image withName:kPhotoName];
        NSString *fullPath = [[FileUtil getCachePathFor:kImageCachePath] stringByAppendingPathComponent:kPhotoName];
        
        NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&frm[content_name]=%@&frm[content_contact]=%@&frm[content_linkname]=%@&frm[content_address]=%@&frm[content_wz]=%@",HTTP,UserInfoEditUrl,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd],self.corp_name,self.content_tel,[self.contact stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.site];
        NSLog(@"%@",url);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSURL *filePath = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@",fullPath]];
        [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"content_img" error:nil];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = (NSDictionary *)responseObject;
            
            if([[dic objectForKey:@"status"] integerValue] == 1)
            {
                is_edit = NO;
                [self download];
            }
            [self.view makeToast:[dic objectForKey:@"msg"]];
            [self.indicator LoadSuccess];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeToast:NO_NET];
            [self.indicator LoadSuccess];
        }];
    }
    else
    {
        is_edit = !is_edit;
    }
    [_mtableview reloadData];
}

#pragma mark - JRDelegate
- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 修改头像
- (void)settitleImage:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"我的相册", nil];
    [sheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(buttonIndex == 0)
        {
            [self openCamera];
        }
        else if(buttonIndex == 1)
        {
            [self openPics];
        }
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [self back:nil];
}
// 打开相机
- (void)openCamera {
    // UIImagePickerControllerCameraDeviceRear 后置摄像头
    // UIImagePickerControllerCameraDeviceFront 前置摄像头
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        NSLog(@"没有摄像头");
        [self.view makeToast:@"抱歉,您的设备不具备摄像功能!"];
        return ;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    // 编辑模式
    imagePicker.allowsEditing = YES;
    
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
}


// 打开相册
- (void)openPics {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self  presentViewController:imagePicker animated:YES completion:^{
    }];
    
    
}


// 选中照片

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width*scale) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
            
            if(self.selfimage == nil)
            {
                [self.view makeToast:@"请选择您要上传的图片"];
                return;
            }
        }];
    }];
    
    
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 保存图片至沙盒

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName {
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *path = [[FileUtil getCachePathFor:kImageCachePath] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:path atomically:NO];
    DLog(@"%@",path);
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.selfimage = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        CorpInfoTableViewCell * cell = (CorpInfoTableViewCell *)[_mtableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.content_titleImg.image = self.selfimage;
        
        if (IOS7) { // 判断是否是IOS7
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            
        }
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        if (IOS7) { // 判断是否是IOS7
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            
        }
        
    }];
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
