//
//  GooglePlusHelper.m
//
//  Created by J.L on 2014. 2. 21..
//  Copyright (c) 2015년 Linkable Inc. All rights reserved.
//

#import "GooglePlusHelper.h"
//#import <GoogleOpenSource/GoogleOpenSource.h>
//#import <GooglePlus/GooglePlus.h>


#import "Utility.h"

@interface GooglePlusHelper()
//<GPPSignInDelegate>

@end

@implementation GooglePlusHelper

//static NSString * const kGoogleClientId = @"171366784987-1unevdctefribfeln6vv1ppndr463v09.apps.googleusercontent.com";
static NSString * const kGoogleClientId = @"425508542084-eqmi7paofseg7pgbr2gh4ipl5d0hesup.apps.googleusercontent.com";

//static GooglePlusHelper *sharedSingleton;
//
//+(GooglePlusHelper *)sharedGooglePlusHelper
//{
//    @synchronized(self)
//    {
//        if (!sharedSingleton)
//        {
//            sharedSingleton = [[GooglePlusHelper alloc] init];
//        }
//        
//        return sharedSingleton;
//    }
//}
//
//- (id)init
//{
//    self = [super init];
//    
//    if (self)
//    {
//        [self initGPP];
//    }
//    
//    return self;
//}
//
//
//#pragma mark GPPSignInDelegate
//
//- (void)initGPP
//{
//    GPPSignIn *signIn                   = [GPPSignIn sharedInstance];
//    signIn.shouldFetchGooglePlusUser    = YES;
//    signIn.shouldFetchGoogleUserEmail   = YES;
//    signIn.shouldFetchGoogleUserID      = YES;
//    signIn.clientID                     = kGoogleClientId;
//    signIn.scopes                       = @[kGTLAuthScopePlusLogin];
//    signIn.delegate                     = self;
//}
//
//- (void)login
//{
//    [[GPPSignIn sharedInstance] authenticate];
////    [[GPPSignIn sharedInstance] trySilentAuthentication];
//}
//
//- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
//{
//    if (self.delegate)
//    {
//        if (!error)
//        {
//            self.email = auth.userEmail;
//            
//            GTLServicePlus *plusService = [[GTLServicePlus alloc] init];
//            plusService.retryEnabled = YES;
//            
//            [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
//            
//            GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
//            
//            [plusService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLPlusPerson *person, NSError *error) {
//                
//                if (error)
//                {
//                    [self.delegate didLogin:nil error:error];
//                }
//                else
//                {
//                    NSMutableDictionary *dicPerson = [NSMutableDictionary dictionary];
//                    [dicPerson setObject:person.identifier forKey:@"user_id"];
//                    [dicPerson setObject:[NSString stringWithFormat:@"%@ %@", [[Utility sharedUtility] getValue:person.name.familyName], [[Utility sharedUtility] getValue:person.name.givenName]] forKey:@"nick_name"];
//                    
////                    [dicPerson setObject:person.displayName forKey:@"display_name"];
//                    [dicPerson setObject:auth.userEmail forKey:@"email"];
//                    [dicPerson setObject:auth.accessToken forKey:@"access_token"];
//                    
//                    if (person.image.url != nil)
//                    {
//                        NSArray *arrUrl = [person.image.url componentsSeparatedByString:@"?"];
//                        
//                        if ([arrUrl count] > 1)
//                        {
//                            NSString *url = [NSString stringWithFormat:@"%@?sz=%@", arrUrl[0], @"640"];
//                            [dicPerson setObject:url forKey:@"image_url"];
//                        }
//                        else
//                        {
//                            [dicPerson setObject:person.image.url forKey:@"image_url"];
//                        }
//                    }
//                    
////                    if (person.cover.coverPhoto.url != nil)
////                        [dicPerson setObject:person.cover.coverPhoto.url forKey:@"cover_image"];
//                    
////                    if (person.name.givenName != nil)
////                        [dicPerson setObject:person.name.givenName forKey:@"first_name"];
////                    
////                    if (person.name.familyName != nil)
////                        [dicPerson setObject:person.name.familyName forKey:@"last_name"];
//                    
//                    if (person.currentLocation != nil)
//                        [dicPerson setObject:person.currentLocation forKey:@"location_name"];
//                    
//                    if (person.birthday != nil)
//                        [dicPerson setObject:person.birthday forKey:@"birthday"];
//                    
//                    if (person.gender != nil)
//                        [dicPerson setObject:person.gender forKey:@"gender"];
//                    
//                    [self.delegate didLogin:dicPerson error:error];
//                }
//            }];
//            
//        }
//        else
//        {
//            [self.delegate didLogin:nil error:error];
//        }
//    }
//}
//
//- (NSString *)accessToken
//{
//    return [GPPSignIn sharedInstance].authentication.accessToken;
//}
//
//- (void)signOut
//{
//    [[GPPSignIn sharedInstance] signOut];
//}
//
//- (void)disconnect
//{
//    [[GPPSignIn sharedInstance] disconnect];
//}
//
//- (void)didDisconnectWithError:(NSError *)error
//{
//    if (error)
//    {
//        NSLog(@"Received error %@", error);
//    }
//    else
//    {
//        // The user is signed out and disconnected.
//        // Clean up user data as specified by the Google+ terms.
//    }
//}
@end
