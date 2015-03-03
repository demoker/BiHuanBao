//
//  QrCodeScanningController.m
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/24.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "QrCodeScanningController.h"
#import "ShouQuanSuccessViewController.h"
#import "ShouQuanFailedViewController.h"
#import "CLBCustomAlertView.h"
@interface QrCodeScanningController ()

@end

@implementation QrCodeScanningController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    navBar = [[JRNavgationBar alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, NAVHEIGHT) Option:JRNAVGATIONDEFAULTBAR];
    navBar.delegate = self;
    navBar.backgroundColor = [UIColor clearColor];
    navBar.titleLabel.text = @"二维码扫描";
    navBar.homebtn.hidden = YES;
    [self.view addSubview:navBar];

    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(_boundsImg.frame.origin.x+20, _boundsImg.frame.origin.y+20, _boundsImg.frame.size.width-40, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [_back_View addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(_boundsImg.frame.origin.x+20, _boundsImg.frame.origin.y+20+2*num, _boundsImg.frame.size.width-40, 2);
        if (2*num == _boundsImg.frame.size.height-40) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(_boundsImg.frame.origin.x+20, _boundsImg.frame.origin.y+20+2*num, _boundsImg.frame.size.width-40, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
- (void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeQRCode,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeInterleaved2of5Code,AVMetadataObjectTypeITF14Code,AVMetadataObjectTypeDataMatrixCode] ;
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =_boundsImg.frame;
    [_back_View.layer insertSublayer:self.preview atIndex:0];
    
    
    
    // Start
    [_session startRunning];
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    if([self.delegate respondsToSelector:@selector(returnQrCode:)])
    {
        [self.delegate performSelector:@selector(returnQrCode:) withObject:stringValue];
    }
    if(_is_shouquan)//收券
    {
        NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@&keyword=%@",HTTP,CorpShouCouponUrl,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd],stringValue];
        [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = (NSDictionary *)responseObject;
            if([[dic objectForKey:@"datalist"] count]!=0)
            {
                NSDictionary * dict = [(NSArray *)[dic objectForKey:@"datalist"] lastObject];
                CouponListItem * item = [[CouponListItem alloc]init];
                item.content_name = [dict objectForKey:@"content_name"];
                item.content_img = [dict objectForKey:@"content_img"];
                item.s_code = [dict objectForKey:@"s_code"];
                item.shop_type = [dict objectForKey:@"shop_type"];
                item.is_use = [dict objectForKey:@"is_use"];
                item.is_comment = [dict objectForKey:@"is_comment"];
                item.auto_id = [dict objectForKey:@"auto_id"];
                item.product_id = [dict objectForKey:@"product_id"];
                item.is_return = [dict objectForKey:@"is_return"];
                
                ShouQuanSuccessViewController * success = [[ShouQuanSuccessViewController alloc] initWithNibName:@"ShouQuanSuccessViewController" bundle:nil];
                success.s_code = item.s_code;
                success.autoid = item.auto_id;
                success.mitem = [[CouponListItem alloc]init];
                success.mitem = item;
                [self.navigationController pushViewController:success animated:YES];
            }
            else
            {
                ShouQuanFailedViewController * failed = [[ShouQuanFailedViewController alloc]initWithNibName:@"ShouQuanFailedViewController" bundle:nil];
                [self.navigationController pushViewController:failed animated:YES];
            }
//            if([[dic objectForKey:@"status"] integerValue] == 1)
//            {
//                ShouQuanSuccessViewController * success = [[ShouQuanSuccessViewController alloc] initWithNibName:@"ShouQuanSuccessViewController" bundle:nil];
//                success.s_code = s_code;
//                success.autoid = auto_id;
//                [self.navigationController pushViewController:success animated:YES];
//            }
//            else
//            {
//                ShouQuanFailedViewController * failed = [[ShouQuanFailedViewController alloc]initWithNibName:@"ShouQuanFailedViewController" bundle:nil];
//                [self.navigationController pushViewController:failed animated:YES];
//            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            CLBCustomAlertView * alert = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"请检查您的网络问题!" leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            
            [alert show];
            
        }];
    }
    else
    {
//        NSString * code = [NSString stringWithFormat:@"%@,%@,%@",self.auto_id,self.corp_id,self.btc_price];
        
//        NSMutableString * strcode = [[NSMutableString alloc]initWithString:stringValue];
//        NSArray * arr = [strcode componentsSeparatedByString:@","];
//        NSString * auto_id = [arr objectAtIndex:0];
//        NSString * corp_id = [arr objectAtIndex:1];
//        NSString * btc_price = [arr objectAtIndex:2];
        NSString * url = [NSString stringWithFormat:@"%@%@&ID=%@&PWD=%@%@",HTTP,GetGivingBtcUrl,[[UserLoginInfoManager loginmanager] user],[[UserLoginInfoManager loginmanager] pwd],stringValue];
        [[ELHttpRequestOperation sharedClient] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary * dic = (NSDictionary *)responseObject;
            
            CLBCustomAlertView * alert = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:[dic objectForKey:@"msg"] leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
                
                if([[dic objectForKey:@"status"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:ShouQuanSuccessNotification object:nil];
                    [self back:nil];
                }
                else
                {
                    [_session startRunning];
                }
                
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            
            [alert show];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CLBCustomAlertView * alert = [[CLBCustomAlertView alloc]initWithTitle:@"提示" message:@"请检查您的网络问题!" leftButtonTitle:@"知道了" leftActionBlock:^(CLBCustomAlertView *view) {
                [view dismiss];
            } rightButtonTitle:nil rightActionBlock:^(CLBCustomAlertView *view) {
                
            }];
            
            [alert show];
        }];

    }
    
   }
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:^
         {
             [timer invalidate];
         }];
        
    }
    else
    {
        [_session startRunning];
    }
}


- (void)back:(id)sender
{
    [timer invalidate];
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
