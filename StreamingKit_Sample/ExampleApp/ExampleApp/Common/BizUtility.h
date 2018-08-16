//
//  BizUtility.h
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BizUtility : NSObject

+ (BizUtility *)sharedUtility;
- (void)logout;
- (void)resign;
- (void)registerDevice;
- (void)registerD;
- (void)handleRemoteNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo appOn:(BOOL)isOn;
- (void)G_Event:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;


//팝업되어 있는 화면에서 처이
- (void)moveController:(NSString *)url controller:(UINavigationController *)navi;
//딥링킹으로 전달될 경우
- (void)deeplink:(NSDictionary *)params;
//
- (BOOL)visibleButtonForUrl:(NSString *)url buttton:(UIButton *)btn;


@end
