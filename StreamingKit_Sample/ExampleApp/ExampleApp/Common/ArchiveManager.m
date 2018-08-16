//
//  ArchiveManager.m
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.

#import "ArchiveManager.h"
#import "ArchiveObject.h"
#import "Utility.h"
#import "Addtions.h"

#define kArchiveName	@"HSM_local_20150409"
#define kDecodeKey		@"DATA_KEY"

@interface ArchiveManager()
    
- (NSString *)dataFilePath;
- (NSInteger)getDaysDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB;
    
@end

@implementation ArchiveManager

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
@synthesize last_date;
@synthesize logined_yn;
@synthesize push_yn;
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
@synthesize address;
@synthesize info;
@synthesize favorite;
@synthesize http;
@synthesize https;

static ArchiveManager *obj = nil;

+ (ArchiveManager *)sharedArchiveManager
{
    @synchronized(self)
	{
		if (!obj)
		{
			obj = [[ArchiveManager alloc] init];
		}
	}
    
	return obj;
}

- (void)loadData
{
    self.device_idx                     = @"";
    self.device_id                      = @"";
    self.device_token                   = @"";
	self.user_idx                       = @"-1";
	self.user_id                        = @"";
    self.site_user_id                   = @"";
    self.sns_type_idx                   = @"";
	self.user_pwd                       = @"";
    self.last_name                      = @"";
    self.first_name                     = @"";
    self.nick_name                      = @"";
    self.email                          = @"";
    self.cell_phone                     = @"";
	self.auto_login_yn                  = @"Y";
	self.login_date                     = [[Utility sharedUtility] convertNSDateToNSString:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];
    self.distance                       = @"1";
    self.logined_yn                     = @"N";
    self.push_yn                        = @"Y";
    self.last_date                      = [NSDate date];
    self.current_version                = @"1.0";
    self.last_version                   = @"1.0";
    self.multi_selection_yn             = @"Y";
    self.twitter_access_token           = @"";
    self.twitter_access_token_secret    = @"";
    self.facebook_access_token          = @"";
    self.contributor_request_yn         = @"N";
    self.theme_image_yn                 = @"N";
    self.shop_yn                        = @"N";
    self.latitude                       = @"0";
    self.longitude                      = @"0";
    self.car_model_cd                   = @"";
    self.car_model_name                 = @"";
    self.car_no                         = @"";
    self.adviserCenterCD                = @"";
    self.adviserCenterName              = @"";
    self.adviserName                    = @"";
    self.adviserTel                     = @"";
    self.insuranceName                  = @"";
    self.insuranceCD                    = @"";
    self.insuranceTel                   = @"";
    self.agreement_yn                   = @"N";
    self.address                        = @"";
    self.info                           = [[NSDictionary alloc] init];
    self.favorite                       = [[NSArray alloc] init];
    self.http                           = @"";
    self.https                          = @"";
    
	NSString *filePath = [self dataFilePath];
	
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) 
	{
		NSData *data = [[NSMutableData alloc] initWithContentsOfFile:filePath];
		
		NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
		
		ArchiveObject *dataObject = [unarchiver decodeObjectForKey:kDecodeKey];
		[unarchiver finishDecoding];
        
        self.device_idx                     = dataObject.device_idx;
        self.device_id                      = dataObject.device_id;
        self.device_token                   = dataObject.device_token;
		self.user_idx                       = dataObject.user_idx;
		self.user_id                        = dataObject.user_id;
        self.site_user_id                   = dataObject.site_user_id;
        self.sns_type_idx                   = dataObject.sns_type_idx;
		self.user_pwd                       = dataObject.user_pwd;
        self.last_name                      = dataObject.last_name;
        self.first_name                     = dataObject.first_name;
        self.nick_name                      = dataObject.nick_name;
        self.email                          = dataObject.email;
        self.cell_phone                     = dataObject.cell_phone;
        self.auto_login_yn                  = dataObject.auto_login_yn;
		self.login_date                     = dataObject.login_date;
        self.distance                       = dataObject.distance;
        self.logined_yn                     = dataObject.logined_yn;
        self.last_date                      = dataObject.last_date;
        self.push_yn                        = dataObject.push_yn;
        self.current_version                = dataObject.current_version;
        self.last_version                   = dataObject.last_version;
        self.multi_selection_yn             = dataObject.multi_selection_yn;
        self.twitter_access_token           = dataObject.twitter_access_token;
        self.twitter_access_token_secret    = dataObject.twitter_access_token_secret;
        self.facebook_access_token          = dataObject.facebook_access_token;
        self.contributor_request_yn         = dataObject.contributor_request_yn;
        self.theme_image_yn                 = dataObject.theme_image_yn;
        self.shop_yn                        = dataObject.shop_yn;
        self.latitude                       = dataObject.latitude;
        self.longitude                      = dataObject.longitude;
        self.car_model_cd                   = dataObject.car_model_cd;
        self.car_model_name                 = dataObject.car_model_name;
        self.car_no                         = dataObject.car_no;
        self.adviserCenterCD                = dataObject.adviserCenterCD;
        self.adviserCenterName              = dataObject.adviserCenterCD;
        self.adviserName                    = dataObject.adviserName;
        self.adviserTel                     = dataObject.adviserTel;
        self.insuranceName                  = dataObject.insuranceName;
        self.insuranceCD                    = dataObject.insuranceCD;
        self.insuranceTel                   = dataObject.insuranceTel;
        self.agreement_yn                   = dataObject.agreement_yn;
        self.address                        = dataObject.address;
        self.info                           = dataObject.info;
        self.favorite                       = dataObject.favorite;
        self.http                           = dataObject.http;
        self.https                          = dataObject.https;
    }
}

- (void)commitData
{
	ArchiveObject *dataObject	= [[ArchiveObject alloc] init];
	
    dataObject.device_idx                   = self.device_idx;
    dataObject.device_id                    = self.device_id;
    dataObject.device_token                 = self.device_token;
	dataObject.user_idx                     = self.user_idx;
	dataObject.user_id                      = self.user_id;
    dataObject.site_user_id                 = self.site_user_id;
    dataObject.sns_type_idx                 = self.sns_type_idx;
	dataObject.user_pwd                     = self.user_pwd;
    dataObject.last_name                    = self.last_name;
    dataObject.first_name                   = self.first_name;
    dataObject.nick_name                    = self.nick_name;
    dataObject.email                        = self.email;
    dataObject.cell_phone                   = self.cell_phone;
	dataObject.auto_login_yn                = self.auto_login_yn;
	dataObject.login_date                   = self.login_date;
    dataObject.distance                     = self.distance;
    dataObject.logined_yn                   = self.logined_yn;
    dataObject.last_date                    = self.last_date;
    dataObject.push_yn                      = self.push_yn;
    dataObject.current_version              = self.current_version;
    dataObject.last_version                 = self.last_version;
    dataObject.multi_selection_yn           = self.multi_selection_yn;
    dataObject.twitter_access_token         = self.twitter_access_token;
    dataObject.twitter_access_token_secret  = self.twitter_access_token_secret;
    dataObject.facebook_access_token        = self.facebook_access_token;
    dataObject.contributor_request_yn       = self.contributor_request_yn;
    dataObject.theme_image_yn               = self.theme_image_yn;
    dataObject.shop_yn                      = self.shop_yn;
    dataObject.latitude                     = self.latitude;
    dataObject.longitude                    = self.longitude;
    dataObject.car_model_cd                 = self.car_model_cd;
    dataObject.car_model_name               = self.car_model_name;
    dataObject.car_no                       = self.car_no;
    dataObject.adviserCenterCD              = self.adviserCenterCD;
    dataObject.adviserCenterCD              = self.adviserCenterName;
    dataObject.adviserName                  = self.adviserName;
    dataObject.adviserTel                   = self.adviserTel;
    dataObject.insuranceName                = self.insuranceName;
    dataObject.insuranceCD                  = self.insuranceCD;
    dataObject.insuranceTel                 = self.insuranceTel;
    dataObject.agreement_yn                 = self.agreement_yn;
    dataObject.address                      = self.address;
    dataObject.info                         = self.info;
    dataObject.favorite                     = self.favorite;
    dataObject.http                         = self.http;
    dataObject.https                        = self.https;
	
	NSString *filePath			= [self dataFilePath];
	
	NSMutableData *data			= [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver	= [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:dataObject forKey:kDecodeKey];
	[archiver finishEncoding];
	[data writeToFile:filePath atomically:YES];
}

- (BOOL)availableUpdate 
{
    if (self.last_date == nil)
        return YES;
        
    NSInteger day = [self getDaysDifferenceBetween:self.last_date and:[NSDate date]];
    
    if (day >= 1)
    {
        return YES;
    }
    return NO;
}

- (BOOL)isLogined
{
    if ([self.auto_login_yn isEqualToString:@"Y"])
        return YES;
    
    if(![self.user_id isEqualToString:@""])
        return YES;

    return NO;
}

- (NSInteger)getDaysDifferenceBetween:(NSDate *)dateA and:(NSDate *)dateB 
{    
    if ([dateA isEqualToDate:dateB]) 
        return 0;
    
    NSCalendar * gregorian = 
    [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate * dateToRound = [dateA earlierDate:dateB];
    int flags = (NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay);
    NSDateComponents * dateComponents = 
    [gregorian components:flags fromDate:dateToRound];
    
    NSDate *roundedDate = [gregorian dateFromComponents:dateComponents];
    NSDate *otherDate = (dateToRound == dateA) ? dateB : dateA;
    NSInteger diff = fabs([roundedDate timeIntervalSinceDate:otherDate]);
    NSInteger daysDifference = floor(diff/(24 * 60 * 60));
    
    return daysDifference;
}

- (NSString *)dataFilePath 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = @"";
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];

    for (NSString *item in contents)
    {
//        NSLog(@"=================== %@", item);
        
        if([item contain:[NSString stringWithFormat:@"%@_", kArchiveName]])
        {
            fileName = item;
            break;
        }
    }
    
    if([fileName isEqualToString:@""])
    {
        fileName = [NSString stringWithFormat:@"%@_%@", kArchiveName, @"beautytalk"];
    }
    
    NSString *fileDir = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    //NSLog(@"============ fileDir %@", fileDir);
    
    return fileDir;
}


@end
