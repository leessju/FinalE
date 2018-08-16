//
//  FacebookHelper.m
//
//  Created by J.L on 2014. 2. 21..
//  Copyright (c) 2015년 Linkable Inc. All rights reserved.
//

#import "FacebookHelper.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation FacebookHelper
@synthesize facebookIdentifier;
@synthesize facebookUserFullName;
@synthesize facebookUserName;

static FacebookHelper *sharedSingleton;

+ (FacebookHelper *)sharedSingleton
{
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[FacebookHelper alloc] init];
        }
        
        return sharedSingleton;
    }
}

- (BOOL)restoreStoredFacebookAccountInfo
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *identifier = [userDefault objectForKey:@"BEAUTYTALK_FACEBOOK_IDENTIFIER"];
    
    if (identifier == nil)
        return NO;
    
    self.facebookIdentifier = identifier;
    
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccount *account = [store accountWithIdentifier:identifier];
    
    if (account == nil)
    {
        self.facebookIdentifier = nil;
        [userDefault removeObjectForKey:@"BEAUTYTALK_FACEBOOK_IDENTIFIER"];
        [userDefault synchronize];
        return NO;
    }
    
    self.facebookUserName = account.username;
    self.facebookUserFullName = [[account valueForKey:@"properties"] valueForKey:@"ACPropertyFullName"];
    
    return YES;
}

- (void)clearFacebookSetting
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"BEAUTYTALK_FACEBOOK_IDENTIFIER"];
    [userDefault synchronize];
    
    self.facebookIdentifier = nil;
    self.facebookUserFullName = nil;
    self.facebookUserName = nil;
}

- (void)storeCurrentFacebookUserInfo:(NSString *)aFacebookIdentifier
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:aFacebookIdentifier forKey:@"BEAUTYTALK_FACEBOOK_IDENTIFIER"];
    [userDefault synchronize];
}

- (void)getFacebookAccountInfoWrite:(id)responseTo performSelector:(SEL)aSelector performSelectorError:(SEL)aSelectorError
{
//    , @"publish_actions"
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *facebookType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"1684950485056538",  ACFacebookAppIdKey,
                             [NSArray arrayWithObjects:@"publish_actions", nil], ACFacebookPermissionsKey,
                             ACFacebookAudienceFriends, ACFacebookAudienceKey,
                             nil];
    
    [store requestAccessToAccountsWithType:facebookType options:options completion:^(BOOL granted, NSError *error) {
        
        NSLog(@"%@", error);
        
        if(granted)
        {
            if ([store.accounts count] == 0)
            {
                [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Login at Setting > Facebook", nil) waitUntilDone:NO];
                return;
            }
            
            NSArray *accounts = [store accountsWithAccountType:facebookType];
            ACAccount *account = [accounts lastObject];
            //            ACAccount *account = [store.accounts objectAtIndex:0];
            self.facebookIdentifier = account.identifier;
            self.facebookUserName = account.username;
            self.facebookUserFullName = [[account valueForKey:@"properties"] valueForKey:@"ACPropertyFullName"];
            [self storeCurrentFacebookUserInfo:self.facebookIdentifier];
            
            NSLog(@"account : %@", account);
            
            [responseTo performSelectorOnMainThread:aSelector withObject:self.facebookUserFullName waitUntilDone:NO];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (error == nil)
                {
//                    [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Please allow access Facebook account.", nil) waitUntilDone:NO];
                    [responseTo performSelectorOnMainThread:aSelectorError withObject:@"페이스북 계정을 권한이 필요합니다." waitUntilDone:NO];
                }
                else
                {
                    if (error.code == 2)
                    {
//                        [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Login at Setting > Facebook", nil) waitUntilDone:NO];
                        [responseTo performSelectorOnMainThread:aSelectorError withObject:@"설정 > Facebook 에서 로그인 해주세요." waitUntilDone:NO];
                    }
                    else if([error code]== ACErrorAccountNotFound)
                    {
//                        [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Login at Setting > Facebook", nil) waitUntilDone:NO];
                        [responseTo performSelectorOnMainThread:aSelectorError withObject:@"설정 > Facebook 에서 로그인 해주세요." waitUntilDone:NO];
                    }
                    else if ([error code] == ACErrorPermissionDenied)
                    {
//                        [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Facebook account access denied.", nil) waitUntilDone:NO];
                        [responseTo performSelectorOnMainThread:aSelectorError withObject:@"페이스북 계정 접근이 거부되었습니다." waitUntilDone:NO];
                    }
                    else
                    {
//                        [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Facebook login failed.", nil) waitUntilDone:NO];
                        [responseTo performSelectorOnMainThread:aSelectorError withObject:@"페이스북 로그인이 실패되었습니다." waitUntilDone:NO];
                    }
                }
            });
        }
        
    }];
}

- (void)getFacebookAccountInfo:(id)responseTo performSelector:(SEL)aSelector performSelectorError:(SEL)aSelectorError
{
    if([self restoreStoredFacebookAccountInfo] == YES)
    {
        [responseTo performSelectorOnMainThread:aSelector withObject:self.facebookUserFullName waitUntilDone:NO];;
        return;
    }
    
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *facebookType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"1684950485056538",  ACFacebookAppIdKey,
                             [NSArray arrayWithObjects:@"email", nil], ACFacebookPermissionsKey,
                             ACFacebookAudienceFriends, ACFacebookAudienceKey,
                             nil];
    
    [store requestAccessToAccountsWithType:facebookType options:options completion:^(BOOL granted, NSError *error) {
        NSLog(@"%@", error);
        
        if(granted)
        {
            if ([store.accounts count] == 0)
            {
//                [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Login at Setting > Facebook", nil) waitUntilDone:NO];
                [responseTo performSelectorOnMainThread:aSelectorError withObject:@"설정 > Facebook 에서 로그인 해주세요." waitUntilDone:NO];
                return;
            }
            
            [self getFacebookAccountInfoWrite:responseTo performSelector:aSelector performSelectorError:aSelectorError];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (error == nil)
                {
//                    [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Please allow access Facebook account.", nil) waitUntilDone:NO];
                    [responseTo performSelectorOnMainThread:aSelectorError withObject:@"페이스북 계정을 권한이 필요합니다." waitUntilDone:NO];
                }
                else
                {
                    if (error.code == 2)
                    {
//                        [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Login at Setting > Facebook", nil) waitUntilDone:NO];
                        [responseTo performSelectorOnMainThread:aSelectorError withObject:@"설정 > Facebook 에서 로그인 해주세요." waitUntilDone:NO];
                    }
                    else if([error code]== ACErrorAccountNotFound)
                    {
//                         [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Login at Setting > Facebook", nil) waitUntilDone:NO];
                        [responseTo performSelectorOnMainThread:aSelectorError withObject:@"설정 > Facebook 에서 로그인 해주세요." waitUntilDone:NO];
                    }
                    else if ([error code] == ACErrorPermissionDenied)
                    {
//                        [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Facebook account access denied.", nil) waitUntilDone:NO];
                        [responseTo performSelectorOnMainThread:aSelectorError withObject:@"페이스북 계정 접근이 거부되었습니다." waitUntilDone:NO];
                    }
                    else
                    {
//                        [responseTo performSelectorOnMainThread:aSelectorError withObject:NSLocalizedString(@"Facebook login failed.", nil) waitUntilDone:NO];
                        [responseTo performSelectorOnMainThread:aSelectorError withObject:@"페이스북 로그인이 실패되었습니다." waitUntilDone:NO];
                    }
                }
            });
        }
    }];
}

- (void)uploadPhoto:(UIImage *)image
              title:(NSString *)title
               link:(NSString *)link
         responseTo:(id)responseTo
performSelectorSuccess:(SEL)aSelectorSuccess
performSelectorFail:(SEL)aSelectorFail
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *facebookAccount = [accountStore accountWithIdentifier:self.facebookIdentifier];
    
    if (facebookAccount == nil)
    {
        [responseTo performSelectorOnMainThread:aSelectorFail withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSURL *postURL = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];

    NSString *message = @"";
    
    if (link == nil)
    {
        message = title;
    }
    else
    {
        message = [NSString stringWithFormat:@"%@ %@", title, link];
    }

    NSDictionary *postDict = @{@"message" : message};
    
    SLRequest *aRequest  = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodPOST
                                                        URL:postURL
                                                 parameters:postDict];
    
    [aRequest addMultipartData:UIImagePNGRepresentation(image)
                             withName:@"source"
                                 type:@"multipart/form-data"
                             filename:@"CamptalkImage"];

    [aRequest setAccount:facebookAccount];
    
    [aRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (error == nil)
        {
            [responseTo performSelectorOnMainThread:aSelectorSuccess withObject:nil waitUntilDone:NO];
        }
        else
        {
            [responseTo performSelectorOnMainThread:aSelectorFail withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)requestFacebookUserInfo:(id)responseTo performSelector:(SEL)aSelector performSelectorError:(SEL)aSelectorError
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *facebookAccount = [accountStore accountWithIdentifier:self.facebookIdentifier];
    
    if (facebookAccount == nil)
    {
        [responseTo performSelectorOnMainThread:aSelectorError withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSURL *postURL = [NSURL URLWithString:@"https://graph.facebook.com/me"];
    
    SLRequest *aRequest  = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:postURL
                                                 parameters:nil];
    
    [aRequest setAccount:facebookAccount];
    
    [aRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (error == nil)
        {
            NSMutableDictionary *responseDictionary  = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Response dictionary: %@", responseDictionary);
            
            NSDictionary *errorDic = [responseDictionary objectForKey:@"error"];
            
            if (errorDic != nil)
            {
                __block NSString *errorMessage = [errorDic objectForKey:@"message"];
                
                if (errorMessage != nil)
                {
                    if([errorDic[@"code"] integerValue] == 190)
                    {
                        NSInteger errorSubCode = [errorDic[@"error_subcode"] integerValue];
                        
                        if (errorSubCode == 460)
                        {
                            errorMessage = @"아이폰 설정에 입력된 Facebook 계정의 Password가 변경되었습니다. 다시 시도해 주십시요.";
                        }
                        else if (errorSubCode == 463)
                        {
                            errorMessage = @"아이폰 설정에 입력된 Facebook 계정의 인증이 만료되었습니다. 다시 시도해 주십시요.";
                        }
                        else if (errorSubCode == 467)
                        {
                            errorMessage = @"아이폰 설정에 입력된 Facebook 계정의 인증 토큰값이 잘못되었습니다. 다시 시도해 주십시요.";
                        }
                        
                        [accountStore renewCredentialsForAccount:facebookAccount
                                                      completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                            switch (renewResult) {
                                case ACAccountCredentialRenewResultRenewed:
                                    NSLog(@"Good to go");
                                    break;
                                    
                                case ACAccountCredentialRenewResultRejected:
                                    NSLog(@"User declined permission");
                                    errorMessage = @"유저에 의해 거부되었습니다. 설정을 확인하시고 다시 시도해 주십시요.";
                                    break;
                                    
                                case ACAccountCredentialRenewResultFailed:
                                    NSLog(@"non-user-initiated cancel, you may attempt to retry");
                                    errorMessage = @"초기화가 취소 되었습니다. 잠시 후 다시 시도해 주십시요.";
                                    break;
                                default:
                                    break;
                            }
                                                          
                            [responseTo performSelectorOnMainThread:aSelectorError withObject:errorMessage waitUntilDone:NO];
                        }];
                        
                        return;
                    }
                }
                
                [responseTo performSelectorOnMainThread:aSelectorError withObject:errorMessage waitUntilDone:NO];
                return;
            }
            
            self.facebookUserId = responseDictionary[@"id"];
            [responseTo performSelectorOnMainThread:aSelector withObject:responseDictionary waitUntilDone:NO];
        }
        else
        {
            [responseTo performSelectorOnMainThread:aSelectorError withObject:nil waitUntilDone:NO];
        }
    }];
    
}

- (NSString *)accessToken
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *facebookAccount = [accountStore accountWithIdentifier:self.facebookIdentifier];
    
    if (facebookAccount == nil)
    {
        return nil;
    }
    
    ACAccountCredential *fbCredential = [facebookAccount credential];
    NSString *accessToken = [fbCredential oauthToken];
    NSLog(@"Facebook Access Token: %@", accessToken);
    
    return accessToken;
}

- (void)requestFacebookCover:(id)responseTo performSelector:(SEL)aSelector performSelectorError:(SEL)aSelectorError
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccount *facebookAccount = [accountStore accountWithIdentifier:self.facebookIdentifier];
    
    if (facebookAccount == nil)
    {
        [responseTo performSelectorOnMainThread:aSelectorError withObject:nil waitUntilDone:NO];
        return;
    }
    
    NSURL *postURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/events?fields=cover"]];
    
    SLRequest *aRequest  = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                              requestMethod:SLRequestMethodGET
                                                        URL:postURL
                                                 parameters:nil];
    
    [aRequest setAccount:facebookAccount];
    
    [aRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if (error == nil)
        {
            NSMutableDictionary *responseDictionary  = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"Response dictionary: %@", responseDictionary);
            
            [responseTo performSelectorOnMainThread:aSelector withObject:responseDictionary waitUntilDone:NO];
        }
        else
        {
            [responseTo performSelectorOnMainThread:aSelectorError withObject:nil waitUntilDone:NO];
        }
    }];
    
}
@end
