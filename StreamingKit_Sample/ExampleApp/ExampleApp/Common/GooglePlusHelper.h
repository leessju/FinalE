//
//  GooglePlusHelper.h
//
//  Created by J.L on 2014. 2. 21..
//  Copyright (c) 2015년 Linkable Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GooglePlusHelperDelegate <NSObject>

- (void)didLogin:(NSDictionary *)data error:(NSError *)error;

@end

@interface GooglePlusHelper : NSObject

//+ (GooglePlusHelper *)sharedGooglePlusHelper;
//- (void)login;
//- (NSString *)accessToken;
//- (void)signOut;
//- (void)disconnect;
//
//@property (assign, nonatomic) id<GooglePlusHelperDelegate> delegate;
//@property (strong, nonatomic) NSString *email;

@end
