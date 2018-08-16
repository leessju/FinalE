//
//  Utility.h
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Utility : NSObject
{
    
}

+ (Utility *)sharedUtility;
- (NSString *)stationId:(NSString *)stId;
- (BOOL)isNumeric:(NSString *)inputString;
- (NSDictionary *)dictionaryForKey:(NSString *)key object:(NSString *)value data:(NSMutableArray *)data;
- (void)operation:(id)aTarget selector:(SEL)aSelector;
- (void)operation:(id)aTarget selector:(SEL)aSelector object:(id)aObject;
- (NSString *)convertNSDateToNSString:(NSDate *)aDate format:(NSString *)aFormat;
- (NSDate *)convertNSStringToNSDate:(NSString *)aDate format:(NSString *)aFormat;
- (NSInteger)minuteBetweenDate:(NSString *)strFromDate andDate:(NSString *)strToDate;
- (NSInteger)secondBetweenDate:(NSString *)strFromDate andDate:(NSString *)strToDate;
- (BOOL)isNull:(id)obj;
- (BOOL)isEmpty:(id)obj;
- (NSString *)getValue:(id)obj;
- (NSUInteger)differenceSecondFromNow:(NSString *)date;
- (NSString *)agoText:(NSUInteger)sec;
- (NSString *)differenceTextFromNow:(NSString *)date;
- (NSString *)blank:(NSUInteger)count;
- (BOOL)saveLocalImage:(UIImage *)image file:(NSString *)fileName;
- (NSDictionary *)fileDictionaryForKey:(NSString *)key contain:(NSString *)value data:(NSMutableArray *)data;
- (BOOL)validateEmail:(NSString *)emailString;
//- (NSString *)imageUrl:(NSArray *)images key:(NSString *)keyName size:(CGSize)size;
- (NSString *)toString:(NSArray *)arr key:(NSString *)key;
- (NSString *)convertNumber:(NSString *)str;
- (CGSize)sizeCrop:(UIImage *)img;
- (CGSize)sizeFixCrop:(UIImage *)image;
- (uint64_t)freeDiskspace;
- (NSUInteger)versionInt:(NSString *)str;
- (CGSize)sizeForStickerMaximumImageInDic:(NSDictionary *)dic;
- (void)showProgressHUD;
- (void)closeProgressHUD;
- (void)successProgressHUD:(NSString *)msg;
- (void)errorProgressHUD:(NSString *)msg;
- (void)infoProgressHUD:(NSString *)msg;

- (void)addActivityIndicator:(UIView *)parent;
- (void)removeActivityIndicator:(UIView *)parent;
- (void)showMessageBox:(NSString *)msg;
- (CGFloat)screenScale;
- (void)showMessageBox:(NSString *)msg title:(NSString *)title confirm:(NSString *)confirm;


@end
