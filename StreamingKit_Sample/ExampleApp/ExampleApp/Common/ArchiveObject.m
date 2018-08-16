//
//  ArchiveObject.m
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import "ArchiveObject.h"

@implementation ArchiveObject

@synthesize device_idx;
@synthesize device_id;
@synthesize device_token;
@synthesize user_idx;
@synthesize user_id;
@synthesize site_user_id;
@synthesize sns_type_idx;
@synthesize user_pwd;
@synthesize last_name;
@synthesize first_name;
@synthesize nick_name;
@synthesize email;
@synthesize cell_phone;
@synthesize auto_login_yn;
@synthesize login_date;
@synthesize distance;
@synthesize logined_yn;
@synthesize last_date;
@synthesize current_version;
@synthesize last_version;
@synthesize multi_selection_yn;
@synthesize twitter_access_token;
@synthesize twitter_access_token_secret;
@synthesize facebook_access_token;
@synthesize contributor_request_yn;
@synthesize theme_image_yn;
@synthesize shop_yn;
@synthesize latitude;
@synthesize longitude;
@synthesize car_model_cd;
@synthesize car_model_name;
@synthesize car_no;
@synthesize adviserCenterCD;
@synthesize adviserCenterName;
@synthesize adviserName;
@synthesize adviserTel;
@synthesize insuranceName;
@synthesize insuranceCD;
@synthesize insuranceTel;
@synthesize agreement_yn;
@synthesize address;
@synthesize info;
@synthesize favorite;
@synthesize http;
@synthesize https;

- (NSString *)dataFilePath 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"archive"];
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:self.device_idx forKey:kKeyDeviceIDX];
    [encoder encodeObject:self.device_id forKey:kKeyDeviceID];
    [encoder encodeObject:self.device_token forKey:kKeyDeviceToken];
	[encoder encodeObject:self.user_idx forKey:kKeyUserIDX];
	[encoder encodeObject:self.user_id forKey:kKeyUserID];
    [encoder encodeObject:self.site_user_id forKey:kKeySiteUserID];
    [encoder encodeObject:self.sns_type_idx forKey:kKeySnsTypeIDX];
	[encoder encodeObject:self.user_pwd forKey:kKeyUserPwd];
    [encoder encodeObject:self.last_name forKey:kKeyLastName];
    [encoder encodeObject:self.first_name forKey:kKeyFirstName];
    [encoder encodeObject:self.nick_name forKey:kKeyNickName];
    [encoder encodeObject:self.email forKey:kKeyEmail];
    [encoder encodeObject:self.cell_phone forKey:kKeyCellPhone];
	[encoder encodeObject:self.auto_login_yn forKey:kKeyAutoLogin];
	[encoder encodeObject:self.login_date forKey:kLoginDate];
    [encoder encodeObject:self.distance forKey:kDistance];
    [encoder encodeObject:self.logined_yn forKey:kLoginYN];
    [encoder encodeObject:self.push_yn forKey:kPushYN];
    [encoder encodeObject:self.last_date forKey:kLastDate];
    [encoder encodeObject:self.current_version forKey:kCurrentVersion];
    [encoder encodeObject:self.last_date forKey:kLastVersion];
    [encoder encodeObject:self.multi_selection_yn forKey:kMultiSelection];
    [encoder encodeObject:self.twitter_access_token forKey:kTwitter_AccessToken];
    [encoder encodeObject:self.twitter_access_token_secret forKey:kTwitter_AccessTokenSecret];
    [encoder encodeObject:self.facebook_access_token forKey:kFacebook_AccessToken];
    [encoder encodeObject:self.contributor_request_yn forKey:kContributor_YN];
    [encoder encodeObject:self.theme_image_yn forKey:kTheme_Iamge_YN];
    [encoder encodeObject:self.shop_yn forKey:kShop_YN];
    [encoder encodeObject:self.latitude forKey:kLatitude];
    [encoder encodeObject:self.longitude forKey:kLongitude];
    [encoder encodeObject:self.car_model_cd forKey:kCarModelCD];
    [encoder encodeObject:self.car_model_name forKey:kCarModelName];
    [encoder encodeObject:self.car_no forKey:kCarNo];
    [encoder encodeObject:self.adviserCenterCD forKey:kAdviserCenterCD];
    [encoder encodeObject:self.adviserCenterName forKey:kAdviserCenterName];
    [encoder encodeObject:self.adviserName forKey:kAdviserName];
    [encoder encodeObject:self.adviserTel forKey:kAdviserTel];
    [encoder encodeObject:self.insuranceName forKey:kInsuranceName];
    [encoder encodeObject:self.insuranceCD forKey:kInsuranceCD];
    [encoder encodeObject:self.insuranceTel forKey:kInsuranceTel];
    [encoder encodeObject:self.agreement_yn forKey:kAgreement_YN];
    [encoder encodeObject:self.address forKey:kAddress];
    [encoder encodeObject:self.info forKey:kInfo];
    [encoder encodeObject:self.favorite forKey:kFavorite];
    [encoder encodeObject:self.http forKey:kHttp];
    [encoder encodeObject:self.https forKey:kHttps];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    if ((self = [super init]))
	{
        self.device_idx                     = [decoder decodeObjectForKey:kKeyDeviceIDX];
        self.device_id                      = [decoder decodeObjectForKey:kKeyDeviceID];
        self.device_token                   = [decoder decodeObjectForKey:kKeyDeviceToken];
		self.user_idx                       = [decoder decodeObjectForKey:kKeyUserIDX];
		self.site_user_id                   = [decoder decodeObjectForKey:kKeySiteUserID];
        self.sns_type_idx                   = [decoder decodeObjectForKey:kKeySnsTypeIDX];
		self.user_pwd                       = [decoder decodeObjectForKey:kKeyUserPwd];
        self.last_name                      = [decoder decodeObjectForKey:kKeyLastName];
        self.first_name                     = [decoder decodeObjectForKey:kKeyFirstName];
        self.nick_name                      = [decoder decodeObjectForKey:kKeyNickName];
        self.email                          = [decoder decodeObjectForKey:kKeyEmail];
        self.cell_phone                     = [decoder decodeObjectForKey:kKeyCellPhone];
		self.auto_login_yn                  = [decoder decodeObjectForKey:kKeyAutoLogin];
		self.login_date                     = [decoder decodeObjectForKey:kLoginDate];
        self.distance                       = [decoder decodeObjectForKey:kDistance];
        self.logined_yn                     = [decoder decodeObjectForKey:kLoginYN];
        self.push_yn                        = [decoder decodeObjectForKey:kPushYN];
        self.last_date                      = [decoder decodeObjectForKey:kLastDate];
        self.current_version                = [decoder decodeObjectForKey:kCurrentVersion];
        self.last_version                   = [decoder decodeObjectForKey:kLastVersion];
        self.multi_selection_yn             = [decoder decodeObjectForKey:kMultiSelection];
        self.twitter_access_token           = [decoder decodeObjectForKey:kTwitter_AccessToken];
        self.twitter_access_token_secret    = [decoder decodeObjectForKey:kTwitter_AccessTokenSecret];
        self.facebook_access_token          = [decoder decodeObjectForKey:kFacebook_AccessToken];
        self.contributor_request_yn         = [decoder decodeObjectForKey:kContributor_YN];
        self.theme_image_yn                 = [decoder decodeObjectForKey:kTheme_Iamge_YN];
        self.shop_yn                        = [decoder decodeObjectForKey:kShop_YN];
        self.latitude                       = [decoder decodeObjectForKey:kLatitude];
        self.longitude                      = [decoder decodeObjectForKey:kLongitude];
        self.car_model_cd                   = [decoder decodeObjectForKey:kCarModelCD];
        self.car_model_name                 = [decoder decodeObjectForKey:kCarModelName];
        self.car_no                         = [decoder decodeObjectForKey:kCarNo];
        self.adviserCenterCD                = [decoder decodeObjectForKey:kAdviserCenterCD];
        self.adviserCenterName              = [decoder decodeObjectForKey:kAdviserCenterName];
        self.adviserName                    = [decoder decodeObjectForKey:kAdviserName];
        self.adviserTel                     = [decoder decodeObjectForKey:kAdviserTel];
        self.insuranceName                  = [decoder decodeObjectForKey:kInsuranceName];
        self.insuranceCD                    = [decoder decodeObjectForKey:kInsuranceCD];
        self.insuranceTel                   = [decoder decodeObjectForKey:kInsuranceTel];
        self.agreement_yn                   = [decoder decodeObjectForKey:kAgreement_YN];
        self.address                        = [decoder decodeObjectForKey:kAddress];
        self.info                           = [decoder decodeObjectForKey:kInfo];
        self.favorite                       = [decoder decodeObjectForKey:kFavorite];
        self.http                           = [decoder decodeObjectForKey:kHttp];
        self.https                          = [decoder decodeObjectForKey:kHttps];
    }
	
    return self;
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone 
{	
	ArchiveObject *copy	= [[[self class] allocWithZone:zone] init];
//	copy.level			= [[self.level copyWithZone:zone] autorelease];
    
    return copy;
}


@end
