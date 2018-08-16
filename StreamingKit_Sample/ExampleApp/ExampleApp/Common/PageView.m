//
//  PageView.m
//  smartcamping
//
//  Created by 이 승주 on 12. 6. 27..
//  Copyright (c) 2012년 SJ & greysox Inc . All rights reserved.
//

#import "PageView.h"

//#define SPACE 40
#define SPACE 1
#define MAX_BUFFER_SIZE 3
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define STATUSBAR_ADJUST_GAP (IS_IOS7?20.0f:0.0f)
#define STATUSBAR_ADJUST_GAP_REVERSE (IS_IOS7?0.0f:20.0f)

@interface PageView()

- (void)setup;
- (NSInteger)pageIndexByCalc;
- (void)updateToPage:(NSInteger)page;
- (BOOL)setViewForPage:(NSInteger)page;
- (void)checkViewBuffer:(NSInteger)page;
- (void)checkDirection:(NSInteger)page;
- (void)clearImageView:(UIView *)parentView;

@property (nonatomic, strong) NSMutableDictionary *viewBuffer;
@property (nonatomic, strong) NSDate *dateS;
@property (nonatomic, strong) NSDate *dateE;
@property (nonatomic, assign) NSInteger offsetS;
@property (nonatomic, assign) NSInteger offsetE;
@property (nonatomic, assign) UIInterfaceOrientation orientationWithPage;
@property (nonatomic, assign) BOOL isDecelarationProcess;
@property (nonatomic, assign) BOOL isDragging;

@end


@implementation PageView

@synthesize delegate                = _delegate;
@synthesize scrollView              = _scrollView;
@synthesize viewBuffer              = _viewBuffer;
@synthesize pageIndex               = _pageIndex;
@synthesize interfaceOrientation    = _interfaceOrientation;
@synthesize data                    = _data;
@synthesize maxPageCount            = _maxPageCount;
@synthesize dateS;
@synthesize dateE;
@synthesize offsetS;
@synthesize offsetE;
@synthesize isDecelarationProcess;
@synthesize isDragging;
@synthesize orientationWithPage;
@synthesize parent;

- (id)initWithFrame:(CGRect)frame withTarget:(id<PageViewDelegate>)target
{
    if ((self = [super initWithFrame:frame]))
    {
        _del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
		self.delegate = target;
        
		[self setup];
	}
    
    return self;
}

- (void)setup
{
	_pageIndex          = -1;
    _isRightDirection   = YES;
    _isGotoPage         = NO;
	
	_viewBuffer = [[NSMutableDictionary alloc] init];
	
	self.backgroundColor = [UIColor clearColor];
	
	_scrollView                  = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
	_scrollView.backgroundColor  = [UIColor clearColor];
    _scrollView.clipsToBounds	 = YES;
	_scrollView.pagingEnabled    = (SPACE == 0);
	_scrollView.scrollEnabled    = YES;
    
    _scrollView.showsHorizontalScrollIndicator  = NO;
    _scrollView.showsVerticalScrollIndicator    = NO;
    _scrollView.delegate                        = self;
	[self addSubview:_scrollView];
}


- (void)updateToPage:(NSInteger)page
{
	if(_pageIndex != page)
	{
        [self checkDirection:page];
        
		CGFloat pageWidth	= _scrollView.frame.size.width;
		CGSize	contentSize	= _scrollView.frame.size;
        
        [self checkViewBuffer:page];
        
        BOOL page1 = [self setViewForPage:(page - 1)];
        BOOL page2 = [self setViewForPage:page];
        BOOL page3 = [self setViewForPage:(page + 1)];
        
        if (page1 && !page2 && !page3)
        {
            contentSize.width	= pageWidth * (page + 0) + SPACE * (page + 1);
        }
        else if (page1 && page2 && !page3)
        {
            contentSize.width	= pageWidth * (page + 1) + SPACE * (page + 2);
        }
        else if (!page1 && page2 && !page3)
        {
            
        }
        else
        {
            contentSize.width	= pageWidth * (page + 2) + SPACE * (page + 3);
        }
        
		_scrollView.contentSize = contentSize;
		_pageIndex      = page;
	}
    
}

- (BOOL)setViewForPage:(NSInteger)page
{
	if(page < 0)
		return NO;
    
    if (page > _maxPageCount - 1)
        return NO;
    
	CGFloat offsetX	= _scrollView.frame.size.width * page;
	
	UIView *view = nil;
    
	if((view = [self.viewBuffer objectForKey:[NSNumber numberWithInt:(int)page]]) == nil)
	{
        if (_delegate && [_delegate respondsToSelector:@selector(pageView:viewForPageIndex:)])
        {
            view = (UIView *)[self.delegate pageView:self viewForPageIndex:page];
            [self.viewBuffer setObject:view forKey:[NSNumber numberWithInt:(int)page]];
            CGRect viewFrame    = view.frame;
            viewFrame.origin.x  = view.frame.origin.x + offsetX + SPACE * (page + 1);
            viewFrame.origin.y  = view.frame.origin.y;
            view.frame          = viewFrame;
            [_scrollView addSubview:view];
        }
	}
    
    return YES;
}

- (void)checkViewBuffer:(NSInteger)page
{
	if(_viewBuffer && [_viewBuffer count] > MAX_BUFFER_SIZE)
	{
		for(NSNumber *pageBuffer in [_viewBuffer allKeys])
		{
            if ([pageBuffer intValue] >= page - 1 && [pageBuffer intValue] <= page + 1)
            {
                UIView *view = (UIView *)[_viewBuffer objectForKey:pageBuffer];
                
                if ([pageBuffer intValue] == page)
                {
                    if ([view isKindOfClass:[UIViewBase class]])
                    {
                        [((UIViewBase *)view) didStartProcess:page];
                    }
                }
                else
                {
                    if ([view isKindOfClass:[UIViewBase class]])
                    {
                        [((UIViewBase *)view) didEndProcess:page];
                    }
                }
            }
            else
            {
                UIView *view = [_viewBuffer objectForKey:pageBuffer];
                view.hidden = YES;
                
                if ([view isKindOfClass:[UIViewBase class]])
                {
                    [((UIViewBase *)view) willDestroy];
                }
                
                [view removeFromSuperview];
                view = nil;
                [_viewBuffer removeObjectForKey:pageBuffer];
            }
        }
    }
}

- (void)scrollPossible:(BOOL)isOK
{
    _scrollView.scrollEnabled = isOK;
}

- (void)loadView
{
    for(NSNumber *pageBuffer in [_viewBuffer allKeys])
    {
        UIView *view = [_viewBuffer objectForKey:pageBuffer];
        
        if ([view isKindOfClass:[UIViewBase class]])
        {
            [((UIViewBase *)view) willDestroy];
        }
        
        [view removeFromSuperview];
        view = nil;
        [_viewBuffer removeObjectForKey:pageBuffer];
    }
    
    NSInteger page = 0;
    _pageIndex      = -1;
    
    _isGotoPage = YES;
    [self checkViewBuffer:(NSInteger)page];
    [self updateToPage:page];
    
    NSInteger width = (page + 1) * SPACE + page * (int)_scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
}

- (void)clear
{
    _pageIndex = -1;
    for(NSNumber *pageBuffer in [_viewBuffer allKeys])
    {
        UIView *view = [_viewBuffer objectForKey:pageBuffer];
        
        if ([view isKindOfClass:[UIViewBase class]])
        {
            [((UIViewBase *)view) willDestroy];
        }
        
        [self clearImageView:view];

        [view removeFromSuperview];
        view = nil;
        [_viewBuffer removeObjectForKey:pageBuffer];
    }
}

- (void)clearImageView:(UIView *)parentView
{
    for (UIView *v in parentView.subviews)
    {
        if ([v isKindOfClass:[UIImageView class]])
        {
            ((UIImageView *)v).image = nil;
            [self clearImageView:v];
        }
    }
}

- (void)goToPage:(NSInteger)page
{
    [self goToPage:page animate:NO];
}

- (void)goToPage:(NSInteger)page animate:(BOOL)animated
{
    _pageIndex = -1;
    _isGotoPage = YES;
    [self checkViewBuffer:(NSInteger)page];
    [self updateToPage:page];
    
    
    NSInteger width = (page + 1) * SPACE + page * (int)_scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:animated];
}

- (void)goToPageNumber:(NSNumber *)page
{
    _pageIndex = -1;
    _isGotoPage = YES;
    [self checkViewBuffer:[page integerValue]];
    [self updateToPage:[page integerValue]];
    
    NSInteger width = ([page integerValue] + 1) * SPACE + [page integerValue] * (int)_scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
}

- (void)goToModel:(NSString *)model
{
    NSInteger page = 0;
    
    _isGotoPage = YES;
    
    for(NSNumber *pageBuffer in [_viewBuffer allKeys])
    {
        UIView *view = [_viewBuffer objectForKey:pageBuffer];
        
        if ([view isKindOfClass:[UIViewBase class]])
        {
            [((UIViewBase *)view) willDestroy];
        }
        
        [view removeFromSuperview];
        view = nil;
        [_viewBuffer removeObjectForKey:pageBuffer];
    }
    
    _pageIndex = -1;
    
    [self updateToPage:page];
    
    NSInteger width = (page + 1) * SPACE + page * (int)_scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
}

- (void)checkDirection:(NSInteger)page
{
    if (_pageIndex < page)
    {
        _isRightDirection = YES;
    }
    else if (_pageIndex > page)
    {
        _isRightDirection = NO;
    }
}

- (void)rotation:(UIInterfaceOrientation)orientation
{
//    self.scrollView.frame       = self.frame;
    self.scrollView.frame       = CGRectMake(self.frame.origin.x,
                                             self.scrollView.frame.origin.y,
                                             self.frame.size.width,
                                             self.frame.size.height);
    
    self.orientationWithPage    = orientation;
    self.interfaceOrientation   = orientation;
    
    NSInteger page = _pageIndex;
    _pageIndex = -1;
    [self goToPage:page];
    
    for(NSNumber *pageBuffer in [_viewBuffer allKeys])
    {
        UIViewBase *view = [_viewBuffer objectForKey:pageBuffer];
        
        CGRect rect         = self.parent.frame;
        rect.origin.x       = ([pageBuffer integerValue] + 1) * SPACE + [pageBuffer integerValue] * self.scrollView.frame.size.width;
        rect.origin.y       = view.frame.origin.y;
        
        if (orientation == UIDeviceOrientationPortrait ||
            orientation == UIDeviceOrientationPortraitUpsideDown)
        {
            self.scrollView.clipsToBounds = NO;
            rect.size.height    = rect.size.height - view.frame.origin.y - 44 - STATUSBAR_ADJUST_GAP;
        }
        else
        {
            self.scrollView.clipsToBounds = YES;
            rect.size.height    = rect.size.height - view.frame.origin.y - STATUSBAR_ADJUST_GAP;
        }
        
        view.frame          = rect;
        view.clipsToBounds  = YES;
        
        [view rotation:orientation];
    }
}

- (NSInteger)pageIndexByCalc
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    CGFloat pointX = self.scrollView.contentOffset.x;
    
    if(pointX < 0)
        pointX = 0;
    
    return floor((pointX - (pageWidth / 2 + SPACE + SPACE / 2)) / (pageWidth + SPACE)) + 1;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (_isGotoPage)
//    {
//        return;
//    }
    
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,0)];
    
    NSInteger page = [self pageIndexByCalc];
    
    if (_scrollView.pagingEnabled)
    {
        if ([_viewBuffer count] < 3)
        {
            [self updateToPage:page];
        }
        
    }
    
	for(NSNumber *pageBuffer in [_viewBuffer allKeys])
	{
        UIView *view = (UIView *)[_viewBuffer objectForKey:pageBuffer];
        
        CGPoint point = [view.superview convertPoint:view.frame.origin toView:self];
        
        if ([view isKindOfClass:[UIViewBase class]])
        {
            [((UIViewBase *)view) didScroll:page position:point.x];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didScrollAtPageView:pageIndex:)])
    {
        [self.delegate didScrollAtPageView:self pageIndex:page];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.isDragging)
    {
        self.dateS = [NSDate date];
        self.offsetS = self.scrollView.contentOffset.x;
        self.isDragging = YES;
    }
    
    _isGotoPage = NO;
    
    NSInteger page = [self pageIndexByCalc];
    
	[self updateToPage:page];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.isDragging)
    {
        self.dateE = [NSDate date];
        self.offsetE = self.scrollView.contentOffset.x;
        self.isDragging = NO;
    }
    
    if (!decelerate)
    {
        if (!_scrollView.pagingEnabled)
        {
            NSInteger page = [self pageIndexByCalc];
            
            NSInteger width = (page + 1) * SPACE + page * (int)_scrollView.frame.size.width;
            
            [self.scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
            [self updateToPage:page];
        }
    }
    else
    {

    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (!_scrollView.pagingEnabled)
    {
        NSInteger off = self.offsetE - self.offsetS;

        NSInteger page = [self pageIndexByCalc];
        
        if (abs((int)off) < 160)
        {
            if (off > 0)
            {
                if (page < self.maxPageCount - 1)
                {
                    self.isDecelarationProcess = YES;
                    
                    page++;
                    
                    NSInteger width = (page + 1) * SPACE + page * (int)_scrollView.frame.size.width;
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.25f];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
                    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
                    [UIView commitAnimations];
                }
                else
                {
                    self.isDecelarationProcess = NO;
                }
            }
            else if (off < 0)
            {
                if (page > 0)
                {
                    self.isDecelarationProcess = YES;

                    page--;
                    
                    NSInteger width = (page + 1) * SPACE + page * (int)_scrollView.frame.size.width;
                    
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.25f];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
                    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
                    [UIView commitAnimations];
                }
                else
                {
                    self.isDecelarationProcess = NO;
                }
            }
            else
            {
                self.isDecelarationProcess = NO;
                
                NSInteger page = [self pageIndexByCalc];
                NSInteger width = (page + 1) * SPACE + page * (int)_scrollView.frame.size.width;
                
                [self.scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
                
                [self updateToPage:page];
            }
        }
        else
        {
            self.isDecelarationProcess = NO;
            
            NSInteger page = [self pageIndexByCalc];
            NSInteger width = (page + 1) * SPACE + page * (int)_scrollView.frame.size.width;
            
            [self.scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
            
            [self updateToPage:page];
            
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isGotoPage = NO;
    isDragging = false;
    
    NSInteger page = [self pageIndexByCalc];
    
    if (!_scrollView.pagingEnabled)
    {
        if (!self.isDecelarationProcess)
        {
            NSInteger width = (page + 1) * SPACE + page * (int)_scrollView.frame.size.width;
            
            if (page > 0 && page < self.maxPageCount - 1)
            {
                [self.scrollView setContentOffset:CGPointMake(width, 0) animated:YES];
            }
            else
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.25f];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
                [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
                [UIView commitAnimations];
            }
        }
        else
        {

        }
    }
    
    [self updateToPage:page];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void*)context
{
	if ([finished intValue] == 1)
	{
        [self updateToPage:[self pageIndexByCalc]];
    }
}

- (void)dealloc
{

}

@end
