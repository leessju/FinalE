//
//  PageView.h
//  smartcamping
//
//  Created by 이 승주 on 12. 6. 27..
//  Copyright (c) 2012년 SJ & greysox Inc . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewBase.h"

@class AppDelegate;
@class PageView;

@protocol PageViewDelegate

- (UIView *)pageView:(PageView *)pageView viewForPageIndex:(NSInteger)index;
@optional
- (void)didScrollAtPageView:(PageView *)pageView pageIndex:(NSInteger)index;

@end


@interface PageView : UIView <UIScrollViewDelegate>
{
    AppDelegate *_del;
    
	id __unsafe_unretained _delegate;
	
	UIScrollView *_scrollView;
	NSMutableDictionary *_viewBuffer;
	NSInteger _pageIndex;
    
    UIInterfaceOrientation _interfaceOrientation;
    
    BOOL _isRightDirection;
    BOOL _isGotoPage;
    
    NSMutableArray *_data;
    NSInteger _maxPageCount;
}

- (id)initWithFrame:(CGRect)frame withTarget:(id<PageViewDelegate>) __unsafe_unretained target;
- (void)goToPage:(NSInteger)page;
- (void)goToPage:(NSInteger)page animate:(BOOL)animated;
- (void)goToPageNumber:(NSNumber *)page;
- (void)goToModel:(NSString *)model;
- (void)loadView;
- (void)clear;
- (void)scrollPossible:(BOOL)isOK;
- (void)rotation:(UIInterfaceOrientation)orientation;

@property(nonatomic, assign) id<PageViewDelegate> delegate;
@property(nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
@property(nonatomic, assign) NSInteger pageIndex;
@property(nonatomic, retain) NSMutableArray *data;
@property(nonatomic, assign) NSInteger maxPageCount;
@property(nonatomic, strong) UIView *parent;


@end