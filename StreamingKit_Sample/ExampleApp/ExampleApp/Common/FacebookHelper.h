//
//  FacebookHelper.h
//
//  Created by J.L on 2014. 2. 21..
//  Copyright (c) 2015년 Linkable Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FacebookHelper : NSObject
{
    
}

@property (nonatomic, strong) NSString *facebookIdentifier;
@property (nonatomic, strong) NSString *facebookUserFullName;
@property (nonatomic, strong) NSString *facebookUserName;
@property (nonatomic, strong) NSString *facebookUserId;

+ (FacebookHelper *)sharedSingleton;

- (void)clearFacebookSetting;
- (BOOL)restoreStoredFacebookAccountInfo;
- (void)getFacebookAccountInfo:(id)responseTo
               performSelector:(SEL)aSelector
          performSelectorError:(SEL)aSelectorError;

- (void)uploadPhoto:(UIImage *)image
              title:(NSString *)title
               link:(NSString *)link
         responseTo:(id)responseTo
performSelectorSuccess:(SEL)aSelectorSuccess
performSelectorFail:(SEL)aSelectorFail;

- (void)requestFacebookUserInfo:(id)responseTo
                performSelector:(SEL)aSelector
           performSelectorError:(SEL)aSelectorError;

- (NSString *)accessToken;

- (void)requestFacebookCover:(id)responseTo performSelector:(SEL)aSelector performSelectorError:(SEL)aSelectorError;

@end
