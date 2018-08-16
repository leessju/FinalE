//
//  BizUtility.m
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import "BizUtility.h"
#import "DefinedHeader.h"
//#import "ViewController.h"
#import "ProductViewController.h"
#import "ProductListViewController.h"
#import "UserViewController.h"
#import "EventBoardContentViewController.h"
#import "EventViewController.h"
#import "WebViewController.h"
#import "SeriesViewController.h"
#import "CouponViewController.h"
#import "CommentViewController.h"
#import "CommentProductViewController.h"
#import "WebEmbedViewController.h"
#import "TabBarController.h"
#import "PBWebViewController.h"
#import <XCDYouTubeKit/XCDYouTubeKit.h>

@interface BizUtility() <DataHelperDelegate>

@end

@implementation BizUtility

static BizUtility *obj = nil;

+ (BizUtility *)sharedUtility
{
    @synchronized(self)
    {
        if (!obj)
        {
            obj = [[BizUtility alloc] init];
        }
    }
    
    return obj;
}

- (void)logout
{
    
}

- (void)resign
{

}

- (void)registerDevice
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert |
                                                       UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge |
          UIUserNotificationTypeSound |
          UIUserNotificationTypeAlert)];
    }
    
}

- (void)registerD
{
    NSString *appName	   = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *majorVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *minorVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *appVersion   = [NSString stringWithFormat:@"%@ (%@)",majorVersion, minorVersion];
    
    UIDevice *dev					= [UIDevice currentDevice];
    NSString *deviceUuid			= dev.uniqueGlobalDeviceIdentifier;
    NSString *deviceName			= dev.name;
    NSString *deviceModel			= dev.model;
    NSString *deviceSystemVersion	= dev.systemVersion;
    
    NSString *device_design = @"";
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone )
    {
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        
        if( screenHeight < screenWidth )
        {
            screenHeight = screenWidth;
        }
        
        if( screenHeight > 480 && screenHeight < 667 )
        {
            device_design = @"iPhone 5/5s";
        }
        else if ( screenHeight > 480 && screenHeight < 736 )
        {
            device_design = @"iPhone 6";
        }
        else if ( screenHeight > 480 )
        {
            device_design = @"iPhone 6 Plus";
        }
        else
        {
            device_design = @"iPhone 4/4s";
        }
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @(SCREEN_SIZE.width).stringValue,@"device_screen_width",
                                @(SCREEN_SIZE.height).stringValue,@"device_screen_height",
                                appName, @"app_name",
                                appVersion, @"app_version",
                                deviceUuid,@"device_id",
                                ARCHIVE_MANAGER.device_token, @"device_token",
                                //선택
                                @"iOS",@"device_os_name",
                                deviceSystemVersion, @"device_version",
                                deviceSystemVersion,@"device_os_version",
                                device_design,@"device_design",
                                @"iPhone",@"device_brand",
                                deviceModel,@"device_model",
                                @"Apple",@"device_manufactor",
                                deviceName, @"device_name",
                                @"1", @"device_type_idx",
                                ARCHIVE_MANAGER.user_idx, @"user_idx",
                                nil];
    
    [DATA_HELPER request:P_Device
               actionURL:@"Register"
                  params:dic
                  sucess:^(id response) {
                      
                      if (![response isKindOfClass:[NSDictionary class]])
                      {
                          return;
                      }
                      
//                      NSLog(@"log : %@ %@ %@ %@ %@",
//                            response[@"response_code"],
//                            response[@"response_data_count"],
//                            response[@"response_message"],
//                            response[@"response_option"],
//                            response[@"response_status"]);
                  }
                 failure:^(NSError *error) {
                     [UTIL errorProgressHUD:error.localizedDescription];
                 }];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

- (void)deeplink:(NSDictionary *)params
{
    if([ARCHIVE_MANAGER.user_idx intValue] == 0)
    {
        return;
    }
    
    BOOL isOK = NO;
    
    for (NSString *key in params)
    {
        NSLog(@"딥링크 데이터: %@, %@", key, params[key]);
        
        if([key isEqualToString:@"view_type"])
        {
            isOK = YES;
            break;
        }
    }
    
    if(isOK)
    {
        if (APP_DELEGATE.container.presentedViewController) {
            
            [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
                [self deeplinkSub:params];
            }];
        }
        else
        {
            [self deeplinkSub:params];
        }
    
    }
}

- (void)deeplinkSub:(NSDictionary *)params
{
//https://beauty-talk.app.link?view_type=event_view&event_idx=10
//https://beauty-talk.app.link?view_type=product_view&product_idx=4828
//https://beauty-talk.app.link?view_type=event_board_view&board_idx=298
//https://beauty-talk.app.link?view_type=notice_board_view&board_idx=55
//https://beauty-talk.app.link?view_type=channel_view&channel_idx=5
//https://beauty-talk.app.link?view_type=user_view&user_idx=18
//https://beauty-talk.app.link?view_type=coupon_view&coupon_idx=1
//https://beauty-talk.app.link?view_type=comment_view&comment_idx=1
//https://beauty-talk.app.link?view_type=comment_product_view&comment_idx=1
//https://beauty-talk.app.link?view_type=web_view&url=http://www.ads.co.kr
    
//    NSUInteger event_idx = 0;
//    NSUInteger product_idx = 0;
//    NSUInteger board_idx = 0;
//    NSUInteger channel_idx = 0;
//    NSUInteger user_idx = 0;
//    NSUInteger coupon_idx = 0;
//    NSUInteger comment_idx = 0;
    NSString *view_type = @"";
    
    for (NSString *key in params)
    {
        NSLog(@"딥링크 데이터: %@, %@", key, params[key]);
        
        if([key isEqualToString:@"view_type"])
        {
            view_type = params[key];
        }
    }
    
    if ([view_type isEqualToString:@"event_view"])
    {
        if (params[@"event_idx"])
        {
            EventViewController *viewController = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
            viewController.event_idx = [params[@"event_idx"] intValue];
            //[APP_DELEGATE.mainNaviViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
        }
    }
    else if ([view_type isEqualToString:@"product_view"])
    {
        if (params[@"product_idx"])
        {
            ProductViewController *viewController = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
            viewController.product_idx  = [params[@"product_idx"] intValue];
            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
            //[APP_DELEGATE.mainNaviViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
            //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
        }
    }
    else if ([view_type isEqualToString:@"event_board_view"])
    {
        if (params[@"board_idx"])
        {
            EventBoardContentViewController *viewController = [[EventBoardContentViewController alloc] initWithNibName:@"EventBoardContentViewController" bundle:nil];
            viewController.title = @"이벤트";
            viewController.board_idx = [params[@"board_idx"] intValue];
            //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
        }
    }
    else if ([view_type isEqualToString:@"notice_board_view"])
    {
        if (params[@"board_idx"])
        {
            [DATA_HELPER request:P_Board
                       actionURL:@"GetList"
                          params:@{@"board_idx":params[@"board_idx"]}
                          sucess:^(id response) {
                              
                              if (![response isKindOfClass:[NSDictionary class]])
                              {
                                  return;
                              }
                              
                              if([response[@"response_code"] isEqualToString:@"1000"])
                              {
                                  if ([response[@"response_data_count"] intValue] > 0)
                                  {
                                      NSDictionary *dic = response[@"response_data"][0];
                                      
                                      WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
                                      viewController.content = dic[@"board_content"];
                                      viewController.custom_title = dic[@"board_subject"];
                                      //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
                                      [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                                  }
                              }
                              
                          }
                         failure:^(NSError *error) {
                             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                         }];
        }
    }
    else if ([view_type isEqualToString:@"channel_view"])
    {
        if (params[@"channel_idx"])
        {
            SeriesViewController *viewController = [[SeriesViewController alloc] initWithNibName:@"SeriesViewController" bundle:nil];
            viewController.channel_idx = [params[@"channel_idx"] intValue];
            //[APP_DELEGATE.mainNaviViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
        }
    }
    else if ([view_type isEqualToString:@"user_view"])
    {
        if (params[@"user_idx"])
        {
            UserViewController *viewController = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
            viewController.user_idx = [params[@"user_idx"] intValue];
            //viewController.title = @"유저 정보";
            viewController.isPopup = YES;
            //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
        }
    }
    else if ([view_type isEqualToString:@"coupon_view"])
    {
        if (params[@"coupon_idx"])
        {
            CouponViewController *viewController = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
            viewController.coupon_idx   = [params[@"coupon_idx"] intValue];
            //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
        }
    }
    else if ([view_type isEqualToString:@"web_view"])
    {
        if (params[@"url"])
        {
            NSString *url = params[@"url"];
            
            if ([url contain:@"?"])
            {
                url = [NSString stringWithFormat:@"%@&user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
            }
            else
            {
                url = [NSString stringWithFormat:@"%@?user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
            }
            
            PBWebViewController *viewController = [[PBWebViewController alloc] init];
            UINavigationController *navigationCon = [[UINavigationController alloc] initWithRootViewController:viewController];
            [navigationCon setNavigationBarHidden:YES animated:NO];
            viewController.URL = [NSURL URLWithString:url];
            //[navi presentViewController:navigationCon animated:YES completion:nil];
            
            [APP_DELEGATE.container presentViewController:navigationCon animated:YES completion:nil];
        }
    }
    
    
//    else if ([url contain:@"web_view"])
//    {
//        NSArray *arr = [url componentsSeparatedByString:@"?"];
//        
//        if ([arr count] > 1)
//        {
//            NSString *queryString = arr[1];
//            NSArray *q = [queryString componentsSeparatedByString:@"="];
//            
//            if ([q count] > 1)
//            {
//                if ([q[0] isEqualToString:@"url"])
//                {
//                    NSString *url = q[1];
//                    
//                    if (url)
//                    {
//                        NSLog(@"web view url: %@", url);
//                        //G_TRACKKING(@"Push_I", @"push_all_click", @"coupon_view", [NSNumber numberWithUnsignedInteger:coupon_idx]);
//                        
//                        if ([url contain:@"?"])
//                        {
//                            url = [NSString stringWithFormat:@"%@&user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
//                        }
//                        else
//                        {
//                            url = [NSString stringWithFormat:@"%@?user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
//                        }
//                        
//                        NSLog(@"embed web : %@", url);
//                        
//                        WebEmbedViewController *viewController = [[WebEmbedViewController alloc] initWithNibName:@"WebEmbedViewController" bundle:nil];
//                        viewController.url = url;
//                        
//                        if (APP_DELEGATE.container.presentedViewController) {
//                            
//                            [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
//                                [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
//                            }];
//                        }
//                        else
//                        {
//                            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    
    
//    else if ([view_type isEqualToString:@"comment_view"])
//    {
//        if (params[@"comment_idx"])
//        {
//            
//        }
//    }
//    else if ([view_type isEqualToString:@"comment_product_view"])
//    {
//        if (params[@"comment_prouct_idx"])
//        {
//            
//        }
//    }
    
    
}

- (void)handleRemoteNotification:(UIApplication *)application userInfo:(NSDictionary *)userInfo appOn:(BOOL)isOn
{
    application.applicationIconBadgeNumber = 0;
    
    NSLog(@"isOn : %d", isOn);
    
//    [MAIN_VIEW_CONTROLLER popToRootViewControllerAnimated:NO];

    NSString *url = [userInfo objectForKey:@"custom_data"];
    url = [url stringByReplacingOccurrencesOfString:@"move/" withString:@""];
    url = [url componentsSeparatedByString:@","][0];
    
//    move/event_view?event_idx=2722
//    move/product_view?product_idx=4828
//    move/event_board_view?board_idx=298
//    move/notice_board_view?board_idx=55
//    move/channel_view?channel_idx=5
//    move/user_view?user_idx=18
//    move/coupon_view?coupon_idx=18
//    move/comment_view?comment_idx=18
//    move/comment_product_view?comment_product_idx=18
    
    if ([url contain:@"event_view"])
    {
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        
        if ([arr count] > 1)
        {
            NSString *queryString = arr[1];
            NSArray *q = [queryString componentsSeparatedByString:@"="];
            
            if ([q count] > 1)
            {
                if ([q[0] isEqualToString:@"event_idx"])
                {
                    NSUInteger event_idx = [q[1] intValue];
                    
                    if (event_idx > 0)
                    {
                        NSLog(@"event_idx : %d", (int)event_idx);
                        
                        G_TRACKKING(@"Push_I", @"push_all_click", @"event_view", [NSNumber numberWithUnsignedInteger:event_idx]);
                        
                        EventViewController *viewController = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
                        viewController.event_idx = event_idx;
                        
                        if (APP_DELEGATE.container.presentedViewController) {
                            
                            [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
                                [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                            }];
                        }
                        else
                        {
                            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        }
                        
                        //[APP_DELEGATE.mainNaviViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                    }
                }
            }
        }
    }
    else if ([url contain:@"product_view"])
    {
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        
        if ([arr count] > 1)
        {
            NSString *queryString = arr[1];
            NSArray *q = [queryString componentsSeparatedByString:@"="];
            
            if ([q count] > 1)
            {
                if ([q[0] isEqualToString:@"product_idx"])
                {
                    NSUInteger product_idx = [q[1] intValue];
                    
                    if (product_idx > 0)
                    {
                        NSLog(@"product_idx : %d", (int)product_idx);
                        
                        G_TRACKKING(@"Push_I", @"push_all_click", @"product_view", [NSNumber numberWithUnsignedInteger:product_idx]);
                        
                        ProductViewController *viewController = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
                        viewController.product_idx  = product_idx;
                        
                        if (APP_DELEGATE.container.presentedViewController) {
                            
                            [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
                                [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                            }];
                        }
                        else
                        {
                            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        }
                        
                        //[APP_DELEGATE.mainNaviViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
                    }
                }
            }
        }
    }
    else if ([url contain:@"event_board_view"])
    {
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        
        if ([arr count] > 1)
        {
            NSString *queryString = arr[1];
            NSArray *q = [queryString componentsSeparatedByString:@"="];
            
            if ([q count] > 1)
            {
                if ([q[0] isEqualToString:@"board_idx"])
                {
                    NSUInteger board_idx = [q[1] intValue];
                    
                    if (board_idx > 0)
                    {
                        NSLog(@"event board_idx : %d", (int)board_idx);
                        G_TRACKKING(@"Push_I", @"push_all_click", @"event_board_view", [NSNumber numberWithUnsignedInteger:board_idx]);
                        
                        EventBoardContentViewController *viewController = [[EventBoardContentViewController alloc] initWithNibName:@"EventBoardContentViewController" bundle:nil];
                        viewController.title = @"이벤트";
                        viewController.board_idx = board_idx;
                        //[APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        
                        if (APP_DELEGATE.container.presentedViewController) {
                            
                            [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
                                [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                            }];
                        }
                        else
                        {
                            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        }
                        
                        //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
                    }
                }
            }
        }
    }
    else if ([url contain:@"notice_board_view"])
    {
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        
        if ([arr count] > 1)
        {
            NSString *queryString = arr[1];
            NSArray *q = [queryString componentsSeparatedByString:@"="];
            
            if ([q count] > 1)
            {
                if ([q[0] isEqualToString:@"board_idx"])
                {
                    NSUInteger board_idx = [q[1] intValue];
                    
                    if (board_idx > 0)
                    {
                        NSLog(@"notice board_idx : %d", (int)board_idx);
                        G_TRACKKING(@"Push_I", @"push_all_click", @"notice_board_view", [NSNumber numberWithUnsignedInteger:board_idx]);
                        
                        [DATA_HELPER request:P_Board
                                   actionURL:@"GetList"
                                      params:@{@"board_idx":@(board_idx).stringValue}
                                      sucess:^(id response) {
                                          
                                          if (![response isKindOfClass:[NSDictionary class]])
                                          {
                                              return;
                                          }
                                          
                                          if([response[@"response_code"] isEqualToString:@"1000"])
                                          {
                                              if ([response[@"response_data_count"] intValue] > 0)
                                              {
                                                  NSDictionary *dic = response[@"response_data"][0];
                                                  
                                                  WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
                                                  viewController.content = dic[@"board_content"];
                                                  viewController.custom_title = dic[@"board_subject"];
                                                  
                                                  if (APP_DELEGATE.container.presentedViewController) {
                                                      
                                                      [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
                                                          [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                                                      }];
                                                  }
                                                  else
                                                  {
                                                      [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                                                  }
                                                  
                                                  //[APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                                                  //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
                                                  
                                              }
                                          }
                                          
                                      }
                                     failure:^(NSError *error) {
                                         [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                     }];
                        
                    }
                }
            }
            
        }
    }
    else if ([url contain:@"channel_view"])
    {
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        
        if ([arr count] > 1)
        {
            NSString *queryString = arr[1];
            NSArray *q = [queryString componentsSeparatedByString:@"="];
            
            if ([q count] > 1)
            {
                if ([q[0] isEqualToString:@"channel_idx"])
                {
                    NSUInteger channel_idx = [q[1] intValue];
                    
                    if (channel_idx > 0)
                    {
                        NSLog(@"channel_idx : %d", (int)channel_idx);
                        G_TRACKKING(@"Push_I", @"push_all_click", @"channel_view", [NSNumber numberWithUnsignedInteger:channel_idx]);
                        
                        SeriesViewController *viewController = [[SeriesViewController alloc] initWithNibName:@"SeriesViewController" bundle:nil];
                        viewController.channel_idx = channel_idx;
                        
                        if (APP_DELEGATE.container.presentedViewController) {
                            
                            [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
                                [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                            }];
                        }
                        else
                        {
                            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        }
                        
                        //[APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        //[APP_DELEGATE.mainNaviViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                    }
                }
            }
        }
    }
    else if ([url contain:@"user_view"])
    {
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        
        if ([arr count] > 1)
        {
            NSString *queryString = arr[1];
            NSArray *q = [queryString componentsSeparatedByString:@"="];
            
            if ([q count] > 1)
            {
                if ([q[0] isEqualToString:@"user_idx"])
                {
                    NSUInteger user_idx = [q[1] intValue];
                    
                    if (user_idx > 0)
                    {
                        NSLog(@"user_idx : %d", (int)user_idx);
                        G_TRACKKING(@"Push_I", @"push_all_click", @"user_view", [NSNumber numberWithUnsignedInteger:user_idx]);
                        
                        UserViewController *viewController = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
                        viewController.user_idx = user_idx;
                        //viewController.title = @"유저 정보";
                        viewController.isPopup = YES;
                        
                        if (APP_DELEGATE.container.presentedViewController) {
                            
                            [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
                                [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                            }];
                        }
                        else
                        {
                            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        }
                        
                        //[APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
                    }
                }
            }
            
        }
    }
    else if ([url contain:@"coupon_view"])
    {
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        
        if ([arr count] > 1)
        {
            NSString *queryString = arr[1];
            NSArray *q = [queryString componentsSeparatedByString:@"="];
            
            if ([q count] > 1)
            {
                if ([q[0] isEqualToString:@"coupon_idx"])
                {
                    NSUInteger coupon_idx = [q[1] intValue];
                    
                    if (coupon_idx > 0)
                    {
                        NSLog(@"coupon_idx : %d", (int)coupon_idx);
                        G_TRACKKING(@"Push_I", @"push_all_click", @"coupon_view", [NSNumber numberWithUnsignedInteger:coupon_idx]);
                        
                        CouponViewController *viewController = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
                        viewController.coupon_idx = coupon_idx;
                        
                        if (APP_DELEGATE.container.presentedViewController) {
                            
                            [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
                                [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                            }];
                        }
                        else
                        {
                            [APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        }
                        
                        //[APP_DELEGATE.container presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        //[APP_DELEGATE.mainNaviViewController pushViewController:viewController animated:YES];
                    }
                }
            }
        }
    }
    else if ([url contain:@"web_view"])
    {
        NSArray *arr = [url componentsSeparatedByString:@"?"];
        
        if ([arr count] > 1)
        {
            NSString *queryString = arr[1];
            NSArray *q = [queryString componentsSeparatedByString:@"="];
            
            if ([q count] > 1)
            {
                if ([q[0] isEqualToString:@"url"])
                {
                    NSString *url = q[1];
                    
                    if (url)
                    {
                        NSLog(@"web view url: %@", url);
                        //G_TRACKKING(@"Push_I", @"push_all_click", @"coupon_view", [NSNumber numberWithUnsignedInteger:coupon_idx]);
                        
                        if ([url contain:@"?"])
                        {
                            url = [NSString stringWithFormat:@"%@&user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
                        }
                        else
                        {
                            url = [NSString stringWithFormat:@"%@?user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
                        }

                        NSLog(@"embed web : %@", url);
                        
                        
                        PBWebViewController *viewController = [[PBWebViewController alloc] init];
                        UINavigationController *navigationCon = [[UINavigationController alloc] initWithRootViewController:viewController];
                        [navigationCon setNavigationBarHidden:YES animated:NO];
                        viewController.URL = [NSURL URLWithString:url];
                        //[navi presentViewController:navigationCon animated:YES completion:nil];
                        
                        if (APP_DELEGATE.container.presentedViewController) {
                            
                            [APP_DELEGATE.container dismissViewControllerAnimated:NO completion:^{
                                [APP_DELEGATE.container presentViewController:navigationCon animated:YES completion:nil];
                            }];
                        }
                        else
                        {
                            [APP_DELEGATE.container presentViewController:navigationCon animated:YES completion:nil];
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
//    else if ([url contain:@"web_view"])
//    {
//        NSArray *arr = [url componentsSeparatedByString:@"?"];
//        
//        if ([arr count] > 1)
//        {
//            NSString *queryString = arr[1];
//            NSArray *q = [queryString componentsSeparatedByString:@"="];
//            
//            if ([q count] > 1)
//            {
//                if ([q[0] isEqualToString:@"url"])
//                {
//                    NSString *url = q[1];
//                    
//                    if (url)
//                    {
//                        NSLog(@"web view url: %@", url);
//                        
//                        if ([url contain:@"?"])
//                        {
//                            url = [NSString stringWithFormat:@"%@&user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
//                        }
//                        else
//                        {
//                            url = [NSString stringWithFormat:@"%@?user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
//                        }
//                        
//                        NSLog(@"embed web : %@", url);
//                        
//                        WebEmbedViewController *viewController = [[WebEmbedViewController alloc] initWithNibName:@"WebEmbedViewController" bundle:nil];
//                        viewController.url = url;
//                        [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
//                    }
//                }
//            }
//        }
//    }
    
    
}

- (BOOL)visibleButtonForUrl:(NSString *)url buttton:(UIButton *)btn
{
    url = [url lowercaseString];
    
    if ([url isEqualToString:@""])
    {
        if (btn != nil)
        {
            btn.hidden = YES;
        }
        
        return NO;
    }
    else if ([url contain:@"http://"])
    {
//        if (![self validateUrl:url])
//        {
//            if (btn != nil)
//            {
//                btn.hidden = YES;
//            }
//            
//            return;
//        }
        return YES;
    }
    else if ([url contain:@"https://"])
    {
//        if (![self validateUrl:url])
//        {
//            if (btn != nil)
//            {
//                btn.hidden = YES;
//            }
//            
//            
//        }
        return YES;
    }
    else if ([url contain:@"beautytalk://"])
    {
//        if (![self validateUrl:url])
//        {
//            if (btn != nil)
//            {
//                btn.hidden = YES;
//            }
//            
//            
//        }
        return YES;
    }
    else if ([url contain:@"://"])
    {
        //        if (![self validateUrl:url])
        //        {
        //            if (btn != nil)
        //            {
        //                btn.hidden = YES;
        //            }
        //
        //            
        //        }
        return YES;
    }
    else
    {
        if (btn != nil)
        {
            btn.hidden = YES;
        }
        
        return NO;
    }
}

- (void)moveController:(NSString *)url controller:(UINavigationController *)navi
{
    NSLog(@"moveController:(NSString *)url controller:(UINavigationController *)navi => %@", url);
    
    //url = [url lowercaseString];
    
    NSString *urlRegEx = @"^(?:https?:\\/\\/)?(?:www\\.)?(?:youtu\\.be\\/|youtube\\.com\\/(?:embed\\/|v\\/|watch\\?v=|watch\\?.+&v=))((\\w|-){11})(?:\\S+)?$";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    BOOL isYoutuble = [urlTest evaluateWithObject:url];
    
    if (isYoutuble)
    {
        NSString *video_id = [self extractYoutubeID:url];
        
        NSLog(@"video_id : %@", video_id);
        
        if (video_id)
        {
            XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:video_id];
            [navi presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
        }
        
        return;
    }
    
//    if ([url contain:@"http://"])
    if ([url hasPrefix:@"http://"])
    {
//        if (![self validateUrl:url])
//        {
//            return;
//        }
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    //else if ([url contain:@"https://"])
    else if ([url hasPrefix:@"https://"])
    {
//        if (![self validateUrl:url])
//        {
//            return;
//        }
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
    //else if ([url contain:@"beautytalk://"])
    else if ([url hasPrefix:@"beautytalk://"])
    {
        NSLog(@"url ==============> %@", url);
        url = [url stringByReplacingOccurrencesOfString:@"beautytalk://" withString:@""];
        url = [url componentsSeparatedByString:@","][0];
        
        if ([url contain:@"event_view"])
        {
            NSArray *arr = [url componentsSeparatedByString:@"?"];
            
            if ([arr count] > 1)
            {
                NSString *queryString = arr[1];
                NSArray *q = [queryString componentsSeparatedByString:@"="];
                
                if ([q count] > 1)
                {
                    if ([q[0] isEqualToString:@"event_idx"])
                    {
                        NSUInteger event_idx = [q[1] intValue];
                        
                        if (event_idx > 0)
                        {
                            NSLog(@"event_idx : %d", (int)event_idx);
                            
                            EventViewController *viewController = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
                            viewController.event_idx = event_idx;
                            [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        }
                    }
                }
            }
        }
        else if ([url contain:@"product_view"])
        {
            NSArray *arr = [url componentsSeparatedByString:@"?"];
            
            if ([arr count] > 1)
            {
                NSString *queryString = arr[1];
                NSArray *q = [queryString componentsSeparatedByString:@"="];
                
                if ([q count] > 1)
                {
                    if ([q[0] isEqualToString:@"product_idx"])
                    {
                        NSUInteger product_idx = [q[1] intValue];
                        
                        if (product_idx > 0)
                        {
                            NSLog(@"product_idx : %d", (int)product_idx);
                            
                            ProductViewController *viewController = [[ProductViewController alloc] initWithNibName:@"ProductViewController" bundle:nil];
                            viewController.product_idx  = product_idx;
                            [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                            //[APP_DELEGATE.mainNaviViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
//                            viewController.title = @"상품정보";
                            //[navi pushViewController:viewController animated:YES];
                        }
                    }
                }
            }
        }
        else if ([url contain:@"product_list_view"])
        {
            NSArray *arr = [url componentsSeparatedByString:@"?"];
            
            if ([arr count] > 1)
            {
                NSString *queryString = arr[1];
                
                NSArray *keys = [queryString componentsSeparatedByString:@"&"];
                
                NSString *event_idx = @"";
                NSString *step_idx  = @"";
                
                for(NSString *keyStr in keys)
                {
                    NSArray *q = [keyStr componentsSeparatedByString:@"="];
                    
                    if ([q count] > 1)
                    {
                        if ([q[0] isEqualToString:@"event_idx"])
                        {
                            event_idx = q[1];
                        }
                        else if ([q[0] isEqualToString:@"step_idx"])
                        {
                            step_idx = q[1];
                        }
                    }
                }
                
                if (![event_idx isEqualToString:@""] && ![step_idx isEqualToString:@""])
                {
                    NSLog(@"event_idx %@ step_idx %@", event_idx, step_idx);
                    
                    [DATA_HELPER request:P_Product
                               actionURL:@"GetByStep"
                                  params:@{@"event_idx":event_idx, @"step_idx":step_idx}
                                  sucess:^(id response) {
                                      
                                      if (![response isKindOfClass:[NSDictionary class]])
                                      {
                                          return;
                                      }
                                      
                                      if([response[@"response_code"] isEqualToString:@"1000"])
                                      {
                                          if ([response[@"response_data_count"] intValue] > 0)
                                          {
                                              ProductListViewController *viewController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
                                              viewController.dataProduct = response[@"response_data"];
                                              //[navi pushViewController:viewController animated:YES];
                                              [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                                          }
                                      }
                                      
                                  }
                                 failure:^(NSError *error) {
                                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                 }];
                    
                }
            }
        }
        else if ([url contain:@"event_board_view"])
        {
            NSArray *arr = [url componentsSeparatedByString:@"?"];
            
            NSLog(@"1");
            
            if ([arr count] > 1)
            {
                NSLog(@"2");
                NSString *queryString = arr[1];
                NSArray *q = [queryString componentsSeparatedByString:@"="];
                
                if ([q count] > 1)
                {
                    NSLog(@"3");
                    if ([q[0] isEqualToString:@"board_idx"])
                    {
                        NSUInteger board_idx = [q[1] intValue];
                        
                        NSLog(@"4");
                        if (board_idx > 0)
                        {
                            NSLog(@"5");
                            NSLog(@"event board_idx : %d", (int)board_idx);
                            
                            EventBoardContentViewController *viewController = [[EventBoardContentViewController alloc] initWithNibName:@"EventBoardContentViewController" bundle:nil];
                            viewController.title = @"이벤트";
                            viewController.board_idx = board_idx;
                            [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                            //[navi pushViewController:viewController animated:YES];
                        }
                    }
                }
            }
        }
        else if ([url contain:@"notice_board_view"])
        {
            NSArray *arr = [url componentsSeparatedByString:@"?"];
            
            if ([arr count] > 1)
            {
                NSString *queryString = arr[1];
                NSArray *q = [queryString componentsSeparatedByString:@"="];
                
                if ([q count] > 1)
                {
                    if ([q[0] isEqualToString:@"board_idx"])
                    {
                        NSUInteger board_idx = [q[1] intValue];
                        
                        if (board_idx > 0)
                        {
                            NSLog(@"notice board_idx : %d", (int)board_idx);
                            
                            [DATA_HELPER request:P_Board
                                       actionURL:@"GetList"
                                          params:@{@"board_idx":@(board_idx).stringValue}
                                          sucess:^(id response) {
                                              
                                              if (![response isKindOfClass:[NSDictionary class]])
                                              {
                                                  return;
                                              }
                                              
                                              if([response[@"response_code"] isEqualToString:@"1000"])
                                              {
                                                  if ([response[@"response_data_count"] intValue] > 0)
                                                  {
                                                      NSDictionary *dic = response[@"response_data"][0];
                                                      
                                                      WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
                                                      viewController.content = dic[@"board_content"];
                                                      viewController.custom_title = dic[@"board_subject"];
                                                      [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                                                      //[navi pushViewController:viewController animated:YES];
                                                      
                                                  }
                                              }
                                              
                                          }
                                         failure:^(NSError *error) {
                                             [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                         }];
                            
                        }
                    }
                }
                
            }
        }
        else if ([url contain:@"channel_view"])
        {
            NSArray *arr = [url componentsSeparatedByString:@"?"];
            
            if ([arr count] > 1)
            {
                NSString *queryString = arr[1];
                NSArray *q = [queryString componentsSeparatedByString:@"="];
                
                if ([q count] > 1)
                {
                    if ([q[0] isEqualToString:@"channel_idx"])
                    {
                        NSUInteger channel_idx = [q[1] intValue];
                        
                        if (channel_idx > 0)
                        {
                            NSLog(@"channel_idx : %d", (int)channel_idx);
                            
                            SeriesViewController *viewController = [[SeriesViewController alloc] initWithNibName:@"SeriesViewController" bundle:nil];
                            viewController.channel_idx = channel_idx;
                            [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                        }
                    }
                }
            }
        }
        else if ([url contain:@"user_view"])
        {
            NSArray *arr = [url componentsSeparatedByString:@"?"];
            
            if ([arr count] > 1)
            {
                NSString *queryString = arr[1];
                NSArray *q = [queryString componentsSeparatedByString:@"="];
                
                if ([q count] > 1)
                {
                    if ([q[0] isEqualToString:@"user_idx"])
                    {
                        NSUInteger user_idx = [q[1] intValue];
                        
                        if (user_idx > 0)
                        {
                            NSLog(@"user_idx : %d", (int)user_idx);
                            
                            if (user_idx == [ARCHIVE_MANAGER.user_idx intValue])
                            {
                                [APP_DELEGATE.tabBarController selectedIndex:4];
                            }
                            else
                            {
                                UserViewController *viewController = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
                                viewController.user_idx = user_idx;
                                //viewController.title = @"유저 정보";
                                viewController.isPopup = YES;
                                [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                                //[navi pushViewController:viewController animated:YES];
                            }
                        }
                    }
                }
                
            }
        }
        else if ([url contain:@"coupon_view"])
        {
            NSArray *arr = [url componentsSeparatedByString:@"?"];
            
            if ([arr count] > 1)
            {
                NSString *queryString = arr[1];
                NSArray *q = [queryString componentsSeparatedByString:@"="];
                
                if ([q count] > 1)
                {
                    if ([q[0] isEqualToString:@"coupon_idx"])
                    {
                        NSUInteger coupon_idx = [q[1] intValue];
                        
                        if (coupon_idx > 0)
                        {
                            NSLog(@"coupon_idx : %d", (int)coupon_idx);
                            
                            CouponViewController *viewController = [[CouponViewController alloc] initWithNibName:@"CouponViewController" bundle:nil];
                            viewController.coupon_idx = coupon_idx;
                            [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
                            //[navi pushViewController:viewController animated:YES];
                        }
                    }
                }
            }
        }
        else if ([url contain:@"web_view"])
        {
            NSArray *arr = [url componentsSeparatedByString:@"?"];
            
            if ([arr count] > 1)
            {
                NSString *queryString = arr[1];
                NSArray *q = [queryString componentsSeparatedByString:@"="];
                
                if ([q count] > 1)
                {
                    if ([q[0] isEqualToString:@"url"])
                    {
                        NSString *url = q[1];
                        
                        if (url)
                        {
                            NSLog(@"web view url: %@", url);
                            
                            if ([url contain:@"?"])
                            {
                                url = [NSString stringWithFormat:@"%@&user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
                            }
                            else
                            {
                                url = [NSString stringWithFormat:@"%@?user_idx=%@", url, ARCHIVE_MANAGER.user_idx];
                            }
                            
                            NSLog(@"embed web : %@", url);
                            
                            PBWebViewController *viewController = [[PBWebViewController alloc] init];
                            UINavigationController *navigationCon = [[UINavigationController alloc] initWithRootViewController:viewController];
                            [navigationCon setNavigationBarHidden:YES animated:NO];
                            viewController.URL = [NSURL URLWithString:url];
                            [navi presentViewController:navigationCon animated:YES completion:nil];
                        }
                    }
                }
            }
        }
//        else if ([url contain:@"comment_view"])
//        {
//            NSArray *arr = [url componentsSeparatedByString:@"?"];
//            
//            if ([arr count] > 1)
//            {
//                NSString *queryString = arr[1];
//                NSArray *q = [queryString componentsSeparatedByString:@"="];
//                
//                if ([q count] > 1)
//                {
//                    if ([q[0] isEqualToString:@"event_idx"])
//                    {
//                        NSUInteger event_idx = [q[1] intValue];
//                        
//                        if (event_idx > 0)
//                        {
//                            NSLog(@"event_idx : %d", (int)event_idx);
//                            
//                            CommentViewController *viewController = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
//                            viewController.event_idx = event_idx;
//                            [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
//                            //[navi pushViewController:viewController animated:YES];
//                        }
//                    }
//                }
//            }
//        }
//        else if ([url contain:@"comment_product_view"])
//        {
//            NSArray *arr = [url componentsSeparatedByString:@"?"];
//            
//            if ([arr count] > 1)
//            {
//                NSString *queryString = arr[1];
//                NSArray *q = [queryString componentsSeparatedByString:@"="];
//                
//                if ([q count] > 1)
//                {
//                    if ([q[0] isEqualToString:@"product_idx"])
//                    {
//                        NSUInteger product_idx = [q[1] intValue];
//                        
//                        if (product_idx > 0)
//                        {
//                            NSLog(@"product_idx : %d", (int)product_idx);
//                            
//                            CommentProductViewController *viewController = [[CommentProductViewController alloc] initWithNibName:@"CommentProductViewController" bundle:nil];
//                            viewController.product_idx = product_idx;
//                            [navi presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
//                            //[navi pushViewController:viewController animated:YES];
//                        }
//                    }
//                }
//            }
//        }
        
//    beautytalk://event_view?event_idx=2722
//    beautytalk://product_view?product_idx=4828
//    beautytalk://event_board_view?board_idx=298
//    beautytalk://notice_board_view?board_idx=55
//    beautytalk://channel_view?channel_idx=5
//    beautytalk://user_view?user_idx=18
//    beautytalk://coupon_view?coupon_idx=299
//    beautytalk://comment_view?comment_idx=1
//    beautytalk://comment_product_view?comment_idx=1
    }
    else
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        else
        {
            [UTIL infoProgressHUD:@"연결될 프로그램이 없습니다."];
        }
    }
}

- (BOOL)validateUrl:(NSString *)candidate
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

- (NSString *)extractYoutubeID:(NSString *)youtubeURL
{
    NSError *error = NULL;
    NSString *regexString = @"(?<=v(=|/))([-a-zA-Z0-9_]+)|(?<=youtu.be/)([-a-zA-Z0-9_]+)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:youtubeURL
                                                         options:0
                                                           range:NSMakeRange(0, [youtubeURL length])];
    if(!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
    {
        NSString *substringForFirstMatch = [youtubeURL substringWithRange:rangeOfFirstMatch];
        return substringForFirstMatch;
    }
    
    return nil;
}

- (void)G_Event:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
    G_EVENT(category, label, label, value);
    
    NSDictionary *dic = nil;
    
    if ([action contain:@"push"])
    {
        dic = @{@"code_value":action,@"user_idx":ARCHIVE_MANAGER.user_idx};
    }
    else
    {
        dic = @{@"code_value":action,@"user_idx":ARCHIVE_MANAGER.user_idx,@"object_idx":value};
    }
    
    [DATA_HELPER request:P_HitLog
               actionURL:@"Add"
                  params:dic
                  sucess:^(id response) {
                      
                      if (![response isKindOfClass:[NSDictionary class]])
                      {
                          return;
                      }
                      
                      if ([[response objectForKey:@"response_data_count"] intValue] > 0)
                      {

                      }
                  }
                 failure:^(NSError *error) {
                     [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                 }];
}

@end
