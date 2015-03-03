//
//  ELTextField.m
//  ilpUser
//
//  Created by elongtian on 14-11-1.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "ELTextField.h"

@implementation ELTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//控制文本所在的的位置，左右缩 5
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 0 );
}

//控制编辑文本时所在的位置，左右缩 5
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 5 , 0 );
}

@end
