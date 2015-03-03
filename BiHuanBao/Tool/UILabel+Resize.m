//
//  UILabel+Resize.m
//  CustomAlertViewDemo
//
//  Created by wei on 14-4-3.
//  Copyright (c) 2014年 vcyber. All rights reserved.
//

#import "UILabel+Resize.h"

@implementation UILabel (Resize)

-(void)resizeHeightToFitText{
    CGRect oldFrame = self.frame;
    CGFloat oldWidth = oldFrame.size.width;
    
    [self sizeToFit];
    
    CGRect newFrame = self.frame;
    newFrame.size.width = oldWidth;
    self.frame = newFrame;
    
    [self setNeedsDisplay];
}

-(void)resizeWidthToFitText{
    CGRect oldFrame = self.frame;
    CGFloat oldHeight = oldFrame.size.height;
    
    [self sizeToFit];
    
    CGRect newFrame = self.frame;
    newFrame.size.height = oldHeight;
    self.frame = newFrame;
    
    [self setNeedsDisplay];
}
@end
