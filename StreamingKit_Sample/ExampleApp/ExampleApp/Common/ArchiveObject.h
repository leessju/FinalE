//
//  ArchiveObject.h
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kKeyDeviceIDX                   @"DEVICE_IDX"
#define kKeyDeviceID                    @"DEVICE_ID"
#define kKeyDeviceToken                 @"DEVICE_TOKEN"
#define kKeyUserIDX                     @"USER_IDX"
#define kKeyUserID                      @"USER_ID"
#define kKeySiteUserID                  @"SITE_USER_ID"
#define kKeySnsTypeIDX                  @"SNS_TYPE_IDX"
#define kKeyLastName                    @"LAST_NAME"
#define kKeyFirstName                   @"FIRST_NAME"
#define kKeyNickName                    @"NICK_NAME"
#define kKeyEmail                       @"EMAIL"
#define kKeyCellPhone                   @"CELL_PHONE"
#define kKeyUserPwd                     @"USER_PWD"
#define kKeyAutoLogin                   @"AUTO_LOGIN"
#define kLoginDate                      @"LOGIN_DATE"
#define kLoginYN                        @"LOGIN_YN"
#define kPushYN                         @"PUSH_YN"
#define kDistance                       @"DISTANCE"
#define kLastDate                       @"LAST_DATE"
#define kCurrentVersion                 @"CURRENT_VERION"
#define kLastVersion                    @"LAST_VERION"
#define kMultiSelection                 @"MULTI_SELECTION"
#define kTwitter_AccessToken            @"TWITTER_ACCESS_TOKEN"
#define kTwitter_AccessTokenSecret      @"TWITTER_ACCESS_TOKEN_SECRET"
#define kFacebook_AccessToken           @"FACEBOOK_ACCESS_TOKEN"
#define kContributor_YN                 @"contributor_request_yn"
#define kTheme_Iamge_YN                 @"theme_image_yn"
#define kShop_YN                        @"shop_yn"
#define kLatitude                       @"LATITUDE"
#define kLongitude                      @"LONGITUDE"
#define kCarModelCD                     @"CAR_MODEL_CD"
#define kCarModelName                   @"CAR_MODEL_NAME"
#define kCarNo                          @"CAR_NO"
#define kAdviserCenterCD                @"AdviserCenterCD"
#define kAdviserCenterName              @"AdviserCenterName"
#define kAdviserName                    @"AdviserName"
#define kAdviserTel                     @"AdviserTel"
#define kInsuranceName                  @"InsuranceName"
#define kInsuranceCD                    @"InsuranceCD"
#define kInsuranceTel                   @"InsuranceTel"
#define kAgreement_YN                   @"Agreement_yn"
#define kAddress                        @"Address"
#define kInfo                           @"Info"
#define kFavorite                       @"Favorite"
#define kHttp                           @"Http"
#define kHttps                          @"Https"

@interface ArchiveObject : NSObject <NSCoding, NSCopying>
{

}

- (NSString *)dataFilePath;

@property (nonatomic, strong) NSString *device_idx;
@property (nonatomic, strong) NSString *device_id;
@property (nonatomic, strong) NSString *device_token;
@property (nonatomic, strong) NSString *user_idx;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *site_user_id;
@property (nonatomic, strong) NSString *sns_type_idx;
@property (nonatomic, strong) NSString *user_pwd;
@property (nonatomic, strong) NSString *last_name;
@property (nonatomic, strong) NSString *first_name;
@property (nonatomic, strong) NSString *nick_name;
@property (nonatomic, strong) NSString *cell_phone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *auto_login_yn;
@property (nonatomic, strong) NSString *login_date;
@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) NSString *logined_yn;
@property (nonatomic, strong) NSString *push_yn;
@property (nonatomic, strong) NSDate *last_date;
@property (nonatomic, strong) NSString *current_version;
@property (nonatomic, strong) NSString *last_version;
@property (nonatomic, strong) NSString *multi_selection_yn;
@property (nonatomic, strong) NSString *twitter_access_token;
@property (nonatomic, strong) NSString *twitter_access_token_secret;
@property (nonatomic, strong) NSString *facebook_access_token;
@property (nonatomic, strong) NSString *contributor_request_yn;
@property (nonatomic, strong) NSString *theme_image_yn;
@property (nonatomic, strong) NSString *shop_yn;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *car_model_cd;
@property (nonatomic, strong) NSString *car_model_name;
@property (nonatomic, strong) NSString *car_no;
@property (nonatomic, strong) NSString *adviserCenterCD;
@property (nonatomic, strong) NSString *adviserCenterName;
@property (nonatomic, strong) NSString *adviserName;
@property (nonatomic, strong) NSString *adviserTel;
@property (nonatomic, strong) NSString *insuranceName;
@property (nonatomic, strong) NSString *insuranceCD;
@property (nonatomic, strong) NSString *insuranceTel;
@property (nonatomic, strong) NSString *agreement_yn;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSArray *favorite;
@property (nonatomic, strong) NSString *http;
@property (nonatomic, strong) NSString *https;

@end
