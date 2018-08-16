//
//  PageControl.h
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageControl;

@protocol PageControlDelegate<NSObject>

- (void)pageControlPageDidChange:(PageControl *)pageControl;

@end

@interface PageControl : UIView 
{
    NSInteger _currentPage;
    NSInteger _numberOfPages;
    UIColor *_dotColorCurrentPage;
    UIColor *_dotColorOtherPage;
    
    id __unsafe_unretained _delegate;
}

- (id)initWithFrame:(CGRect)frame color1:(UIColor *)color1 color2:(UIColor *)color2;

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;
@property (nonatomic, strong) UIColor *dotColorCurrentPage;
@property (nonatomic, strong) UIColor *dotColorOtherPage;
@property (nonatomic, assign) id<PageControlDelegate> __unsafe_unretained delegate;

@end