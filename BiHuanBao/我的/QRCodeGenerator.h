//
//  QRCodeGenerator.h
//  BiHuanBao
//
//  Created by 马东凯 on 14/12/25.
//  Copyright (c) 2014年 demoker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeGenerator : NSObject
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)size;
+ (UIImage *) twoDimensionCodeImage:(UIImage *)twoDimensionCode withAvatarImage:(UIImage *)avatarImage;
@end
