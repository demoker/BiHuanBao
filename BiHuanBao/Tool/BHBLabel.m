//
//  BHBLabel.m
//  BiHuanBao
//
//  Created by 马东凯 on 15/1/24.
//  Copyright (c) 2015年 demoker. All rights reserved.
//

#import "BHBLabel.h"

@interface BHBLabel(){
    
}
@property (nonatomic,retain) NSMutableAttributedString * attriString;
@end

@implementation BHBLabel

//NSMutableAttributedString * _attriString;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setText:(NSString *)text{
    if (text == nil) {
        _attriString = nil;
    }else{
        _attriString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)color.CGColor
                       range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attriString addAttribute:(NSString *)kCTFontAttributeName
                       value:(id)CFBridgingRelease(CTFontCreateWithName((CFStringRef)font.fontName,
                                                                        font.pointSize*2,
                                                                        NULL))
                       range:NSMakeRange(location, length)];
}

// 设置某段字的风格
- (void)setStyle:(CTUnderlineStyle)style fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attriString addAttribute:(NSString *)kCTUnderlineStyleAttributeName
                       value:(id)[NSNumber numberWithInt:style]
                       range:NSMakeRange(location, length)];
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextConcatCTM(ctx, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, rect.size.height), 1.f, -1.f));
//    
//    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attriString);
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathAddRect(path, NULL, rect);
//    
//    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
//    CFRelease(path);
//    CFRelease(framesetter);
//    
//    CTFrameDraw(frame, ctx);
//    CFRelease(frame);
    
}
@end
