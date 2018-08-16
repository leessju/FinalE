//
//  UIViewBase.m
//  smartcamping
//
//  Created by 이 승주 on 12. 6. 27..
//  Copyright (c) 2012년 SJ & greysox Inc . All rights reserved.
//

#import "UIViewBase.h"

@implementation UIViewBase

@synthesize interfaceOrientation = _interfaceOrientation;
@synthesize delegate    = _delegate;

- (void)awakeFromNib 
{
    [super awakeFromNib];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (_delegate && [_delegate respondsToSelector:@selector(didTabToView:)]) 
    {
        [self.delegate didTabToView:nil];
    }
}

- (void)didStartProcess:(NSInteger)page
{
    
}

- (void)didScroll:(NSInteger)page position:(NSInteger)xPos
{
    
}

- (void)didEndProcess:(NSInteger)page
{
    
}

- (void)willDestroy
{
    
}

- (void)roationView:(UIInterfaceOrientation)interfaceOrientation
{
    
}

- (void)rotation:(UIInterfaceOrientation)orientation
{
    
}

//- (void)dealloc 
//{
//    [super dealloc];
//}

@end
