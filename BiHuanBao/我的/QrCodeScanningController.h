//
//  QrCodeScanningController.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/24.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

@protocol QrCodeScanningDelegate <NSObject>

- (void)returnQrCode:(NSString *)code;

@end
@interface QrCodeScanningController : BaseViewController<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>
{
    JRNavgationBar * navBar;
    BOOL upOrdown;
    int num;
    NSTimer * timer;
}
@property (weak, nonatomic) IBOutlet UIView *back_View;
@property (weak, nonatomic) IBOutlet UIImageView *boundsImg;
@property (retain, nonatomic) UIImageView * line;

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (assign, nonatomic) BOOL is_shouquan;//是收券还是发货，
@property (assign, nonatomic) id <QrCodeScanningDelegate>delegate;
@property (retain, nonatomic) NSString * type;
@end
