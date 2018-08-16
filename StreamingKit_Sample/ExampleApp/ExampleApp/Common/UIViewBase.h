//
//  UIViewBase.h
//  smartcamping
//
//  Created by 이 승주 on 12. 6. 27..
//  Copyright (c) 2012년 SJ & greysox Inc . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewBaseDelegate <NSObject>
@optional
- (void)didTouchToLivingPopup:(id)sender data:(NSDictionary *)dicData;
- (void)viewBackBase:(NSString *)imageName;
- (void)didScrollPossible:(BOOL)isOK;
- (void)didTabToView:(UIGestureRecognizer *)gestureRecognizer;
@end

@interface UIViewBase : UIView
{
    id __unsafe_unretained _delegate;
    UIInterfaceOrientation _interfaceOrientation;
}

- (void)didStartProcess:(NSInteger)page;
- (void)didScroll:(NSInteger)page position:(NSInteger)xPos;
- (void)didEndProcess:(NSInteger)page;
- (void)willDestroy;
- (void)roationView:(UIInterfaceOrientation)interfaceOrientation;
- (void)rotation:(UIInterfaceOrientation)orientation;

@property (nonatomic, assign) id<UIViewBaseDelegate> __unsafe_unretained delegate;
@property(nonatomic, assign) UIInterfaceOrientation interfaceOrientation;

@end
