//
//  PageControl.m
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import "PageControl.h"

#define kDotDiameter    7.0
#define kDotSpacer      7.0

@implementation PageControl

@synthesize currentPage         = _currentPage;
@synthesize numberOfPages       = _numberOfPages;
@synthesize dotColorCurrentPage = _dotColorCurrentPage;
@synthesize dotColorOtherPage   = _dotColorOtherPage;
@synthesize delegate            = _delegate;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        self.backgroundColor        = [UIColor clearColor];
        self.dotColorCurrentPage    = [UIColor colorWithRed:0.949 green:0.647 blue:0.278 alpha:1.000];
        self.dotColorOtherPage      = [UIColor whiteColor];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame color1:(UIColor *)color1 color2:(UIColor *)color2
{
    if ((self = [super initWithFrame:frame])) 
    {
        self.backgroundColor        = [UIColor clearColor];
        self.dotColorCurrentPage    = color1;
        self.dotColorOtherPage      = color2;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    CGContextRef context = UIGraphicsGetCurrentContext();   
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages*kDotDiameter + MAX(0, self.numberOfPages-1)*kDotSpacer;
    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
    CGFloat y = CGRectGetMidY(currentBounds)-kDotDiameter/2;
    
    for (int i=0; i<_numberOfPages; i++)
    {
        CGRect circleRect = CGRectMake(x, y, kDotDiameter, kDotDiameter);
        
        if (i == _currentPage)
        {
            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
        }
        CGContextFillEllipseInRect(context, circleRect);
        x += kDotDiameter + kDotSpacer;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.delegate) 
        return;
    
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
    
    CGFloat dotSpanX = self.numberOfPages*(kDotDiameter + kDotSpacer);
    CGFloat dotSpanY = kDotDiameter + kDotSpacer;
    
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX/2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY/2 - CGRectGetMidY(currentBounds);
    
    if ((x<0) || (x>dotSpanX) || (y<0) || (y>dotSpanY)) 
        return;
    
    self.currentPage = floor(x/(kDotDiameter+kDotSpacer));
    
    if ([_delegate respondsToSelector:@selector(pageControlPageDidChange:)])
    {
        [self.delegate pageControlPageDidChange:self];
    }
}

- (NSInteger)currentPage
{
    return _currentPage;
}

- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = MIN(MAX(0, page), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (NSInteger)numberOfPages
{
    return _numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages  = MAX(0, pages);
    _currentPage    = MIN(MAX(0, _currentPage), _numberOfPages-1);
    
    [self setNeedsDisplay];
}

- (void)dealloc 
{

}

@end
