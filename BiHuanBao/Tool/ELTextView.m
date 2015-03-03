//
//  ELTextView.m
//  ilpUser
//
//  Created by elongtian on 14-11-3.
//  Copyright (c) 2014年 madongkai. All rights reserved.
//

#import "ELTextView.h"

@implementation ELTextView
@synthesize placeholder;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addObserver];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
        [self addObserver];
    }
    return self;
}
- (NSString *)text
{
    if([[super text] isEqualToString:placeholder])
        return @"";
    else
        return  [super text];
}

- (void)setPlaceholder:(NSString *)aplaceholder
{
    placeholder = aplaceholder;
    
    [self endEdit:nil];
}
- (void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEdit:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEdit:) name:UITextViewTextDidEndEditingNotification object:self];
}

- (void)beginEdit:(NSNotification *)notifi
{
    if([[super text]isEqualToString:placeholder])
    {
        [super setText:nil];
        [super setTextColor:[UIColor blackColor]];
    }
}

- (void)endEdit:(NSNotification *)notifi
{
    if([[super text] isEqualToString:@""]||[super text] == nil)
    {
        [super setText:placeholder];
        [super setTextColor:[UIColor lightGrayColor]];
    }
}

-(void)removeObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)dealloc
{
    [self removeObserver];
}
@end
