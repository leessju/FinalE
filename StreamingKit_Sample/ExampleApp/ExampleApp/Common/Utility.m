//
//  Utility.m
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import "Utility.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface NSString (MyAdditions)

- (BOOL)contain:(NSString *)substring;

@end


@implementation NSString (MyAdditions)

- (BOOL)contain:(NSString *)substring
{
	if([self length] == 0 || [substring length] == 0)
		return NO;
	
	NSRange textRange;
	
	textRange = [[self lowercaseString] rangeOfString:[substring lowercaseString]];
	
	if(textRange.location != NSNotFound)
	{
		return YES;
	}
	
	return NO;
}

@end


@implementation Utility

static Utility *obj = nil;

+ (Utility *)sharedUtility
{
    @synchronized(self)
	{
		if (!obj)
		{
			obj = [[Utility alloc] init];
		}
	}
    
	return obj;
}

- (BOOL)isNumeric:(NSString *)inputString
{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet       = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key object:(NSString *)value data:(NSMutableArray *)data 
{
    for (NSDictionary *dic in data) 
    {
        if ([[dic objectForKey:key] isEqualToString:value]) 
            return dic;
    }
    
    return nil;
}

- (NSDictionary *)fileDictionaryForKey:(NSString *)key contain:(NSString *)value data:(NSMutableArray *)data
{
    for (NSDictionary *dic in data)
    {
        if ([(NSString *)[dic objectForKey:key] contain:value])
            return dic;
    }
    
    return nil;
}
//
//- (NSString *)imageUrl:(NSArray *)images key:(NSString *)keyName size:(CGSize)size
//{
////    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!! images : %@", images);
//    
//    if (!images)
//        return nil;
//    
//    if ([images isEqual:[NSNull null]])
//        return nil;
//    
//    if ([images count] == 0)
//        return nil;
//    
////    if (!size)
////        size = CGSizeMake(0, 0);
//    
//    size = CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale);
//    
//    if ([images count] == 1)
//    {
////        NSLog(@"%@ image 1 url : %@", keyName, [[images objectAtIndex:0] objectForKey:@"image_url"]);
//        return [[images objectAtIndex:0] objectForKey:@"image_url"];
//    }
//    else
//    {
//        if (keyName)
//        {
//            for (NSDictionary *dic in images)
//            {
//                if ([[dic objectForKey:@"image_key"] isEqual:keyName])
//                {
////                    NSLog(@"%@ key fit url : %@",keyName, [dic objectForKey:@"image_url"]);
//                    return [dic objectForKey:@"image_url"];
//                }
//            }
//            
//            // 만약 키가 없다면
//            NSMutableArray *arr = [[NSMutableArray alloc] init];
//            
//            for (int i = 0; i < [images count]; i++)
//            {
//                NSDictionary *dic = [images objectAtIndex:i];
//                
//                if ([[dic objectForKey:@"image_width"] intValue] >= size.width &&
//                    [[dic objectForKey:@"image_height"] intValue] >= size.height &&
//                    [[dic objectForKey:@"image_width"] intValue] > 0 &&
//                    [[dic objectForKey:@"image_height"] intValue] > 0)
//                {
//                    //                    NSLog(@"(%d, %d) <> (%f, %f)", [[dic objectForKey:@"image_width"] intValue], [[dic objectForKey:@"image_height"] intValue], size.width, size.height);
//                    [arr addObject:dic];
//                }
//            }
//            
//            if ([arr count] == 0)
//            {
////                NSLog(@"%@ default url : %@", keyName, [[images objectAtIndex:0] objectForKey:@"image_url"]);
//                return [[images objectAtIndex:0] objectForKey:@"image_url"];
//            }
//            else
//            {
//                int minVal = [[[arr objectAtIndex:0] objectForKey:@"image_width"] intValue] * [[[arr objectAtIndex:0] objectForKey:@"image_height"] intValue];
//                int rIndex = 0;
//                
//                for (int i = 1; i < [arr count]; i++)
//                {
//                    int nextVal = [[[arr objectAtIndex:i] objectForKey:@"image_width"] intValue] * [[[arr objectAtIndex:i] objectForKey:@"image_height"] intValue];
//                    
//                    if (minVal > nextVal)
//                    {
//                        minVal = nextVal;
//                        rIndex = i;
//                    }
//                }
//                
////                NSLog(@"%@ img fit url : %@", keyName, [[arr objectAtIndex:rIndex] objectForKey:@"image_url"]);
//                return [[arr objectAtIndex:rIndex] objectForKey:@"image_url"];
//            }
//        }
//        else //키가 nil 이면
//        {
//            NSMutableArray *arr = [[NSMutableArray alloc] init];
//            
//            for (int i = 0; i < [images count]; i++)
//            {
//                NSDictionary *dic = [images objectAtIndex:i];
//                
//                if ([[dic objectForKey:@"image_width"] intValue] >= size.width &&
//                    [[dic objectForKey:@"image_height"] intValue] >= size.height &&
//                    [[dic objectForKey:@"image_width"] intValue] > 0 &&
//                    [[dic objectForKey:@"image_height"] intValue] > 0)
//                {
////                    NSLog(@"(%d, %d) <> (%f, %f)", [[dic objectForKey:@"image_width"] intValue], [[dic objectForKey:@"image_height"] intValue], size.width, size.height);
//                    [arr addObject:dic];
//                }
//            }
//            
//            if ([arr count] == 0)
//            {
////                NSLog(@"%@, url : %@", keyName, [[images objectAtIndex:0] objectForKey:@"image_url"]);
//                return [[images objectAtIndex:0] objectForKey:@"image_url"];
//            }
//            else
//            {
//                int minVal = [[[arr objectAtIndex:0] objectForKey:@"image_width"] intValue] * [[[arr objectAtIndex:0] objectForKey:@"image_height"] intValue];
//                int rIndex = 0;
//                
//                for (int i = 1; i < [arr count]; i++)
//                {
//                    int nextVal = [[[arr objectAtIndex:i] objectForKey:@"image_width"] intValue] * [[[arr objectAtIndex:i] objectForKey:@"image_height"] intValue];
//                    
//                    if (minVal > nextVal)
//                    {
//                        minVal = nextVal;
//                        rIndex = i;
//                    }
//                }
//                
////                NSLog(@"%@ key : null size fit url : %@", keyName, [[arr objectAtIndex:rIndex] objectForKey:@"image_url"]);
//                return [[arr objectAtIndex:rIndex] objectForKey:@"image_url"];
//            }
//        }
//    }
//    
//    return nil;
//}
//
- (void)operation:(id)aTarget selector:(SEL)aSelector
{
	[self operation:aTarget selector:aSelector object:nil];
}

- (void)operation:(id)aTarget selector:(SEL)aSelector object:(id)aObject
{
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:aTarget 
																			selector:aSelector
																			  object:aObject];
	NSOperationQueue *queue  = [[NSOperationQueue alloc] init];
	[queue addOperation:operation];
//	[operation release];
//	[queue release];
}

- (NSString *)convertNSDateToNSString:(NSDate *)aDate format:(NSString *)aFormat
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:aFormat];
	return [dateFormat stringFromDate:aDate];
}

- (NSDate *)convertNSStringToNSDate:(NSString *)aDate format:(NSString *)aFormat
{
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:aFormat];
	return [dateFormat dateFromString:aDate];
}

- (BOOL)validateEmail:(NSString *)emailString
{
    NSString *regExPattern      = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
    NSRegularExpression *regEx  = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches     = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];

    if (regExMatches == 0)
        return NO;
    
    return YES;
}

- (BOOL)isNull:(id)obj
{
    if (obj)
    {
        if (![obj isEqual:[NSNull null]])
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isEmpty:(id)obj
{
    if (obj)
    {
        if ([obj isEqual:[NSNull null]])
        {
            return YES;
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            if ([obj isEqualToString:@""])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
        return NO;
    }
    
    return YES;
}

- (NSString *)getValue:(id)obj
{
    if (obj)
    {
        if ([obj isEqual:[NSNull null]])
        {
            return @"";
        }
        else if ([obj isKindOfClass:[NSString class]])
        {
            if ([obj isEqualToString:@""])
            {
                return @"";
            }
            else
            {
                return [NSString stringWithFormat:@"%@", obj];
            }
        }
        
        return [NSString stringWithFormat:@"%@", obj];
    }
    
    return @"";
}


- (CGSize)sizeCrop:(UIImage *)image
{
    CGSize size1;
    
    float rate = image.size.height / image.size.width;
    
    if (rate > 1.77777777777778)
        rate = 1.77777777777778;

    if (image.size.height > image.size.width)
    {
        size1 = CGSizeMake(360.0f, 360 * rate);
    }
    else
    {
        size1 = CGSizeMake(360 / rate, 360);
    }
    
    NSLog(@"_______________________ size1 : %@", NSStringFromCGSize(size1));
    
    return size1;
}

- (CGSize)sizeFixCrop:(UIImage *)image
{
    CGSize size1;
    
    if (image.size.height > image.size.width)
    {
        size1 = CGSizeMake(360.0f, 480.0f);
    }
    else
    {
        size1 = CGSizeMake(480.0f, 360);
    }
    
    return size1;
}


//yyyy : 년도
//w : 일년안에서 몇번째 주인지
//W : 한달안에서 몇번째 주인지
//MM : 월
//dd : 일
//D : 일년에서 몇번째 일인지
//E : 요일 (ex) Tuesday; Tue
//F : 요일을 숫자로 (ex) 2
//hh : 시간 ( 12시간 단위로 1-12)
//kk : 시간 (12시간 단위로 0-11)
//HH : 시간 (24시간 단위로 1-24)
//KK : 시간 (24시간 단위로 0-23)
//a : PM 인지 AM 인지
//mm : 분
//ss : 초. second in minute
//SSS : Millisecond
//zzzz : General time zone (ex) Pacific Standard Time; PST; GMT-08:00
//Z : RFC 822 time zone (ex) -800
//[출처] NSDateFormatter 사용법|작성자 낭만가을

- (NSInteger)minuteBetweenDate:(NSString *)strFromDate andDate:(NSString *)strToDate
{
    NSDate *fromDateTime = [self convertNSStringToNSDate:strFromDate format:@"HH:mm"];
    NSDate *toDateTime   = [self convertNSStringToNSDate:strToDate format:@"HH:mm"];
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitMinute startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitMinute startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitMinute
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference minute];
}

- (NSInteger)secondBetweenDate:(NSString *)strFromDate andDate:(NSString *)strToDate
{
    strFromDate = [strFromDate stringByReplacingOccurrencesOfString:@".0" withString:@""];
    strToDate   = [strToDate stringByReplacingOccurrencesOfString:@".0" withString:@""];
    
    NSDate *fromDateTime = [self convertNSStringToNSDate:strFromDate format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *toDateTime   = [self convertNSStringToNSDate:strToDate format:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitMinute startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitMinute startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitMinute
                                               fromDate:fromDate toDate:toDate options:0];
    
    NSInteger sec = [difference second];
    
    return sec;
    
//    if (sec > 60) 
//    {
//        NSInteger div = sec/60;
//        NSInteger reminder = sec%60;
//    
//        return [NSString stringWithFormat:@"%02d:%02d후 도착", div,reminder];
////        return [NSString stringWithFormat:@"%02d분 후 도착", div,reminder];
//    }
//    
//    return [NSString stringWithFormat:@"%d초 후 도착", sec];
    
//    return [difference second];
}

- (NSString *)differenceTextFromNow:(NSString *)date
{
    NSUInteger sec = [self differenceSecondFromNow:date];
    return [self agoText:sec];
}

- (NSUInteger)differenceSecondFromNow:(NSString *)date
{
    NSDate *fromDateTime = [NSDate date];
    NSDate *toDateTime   = [self convertNSStringToNSDate:date format:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitSecond startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitSecond startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitSecond
                                               fromDate:fromDate toDate:toDate options:0];
    
    NSInteger sec = [difference second];
    
    return abs((int)sec);
}


- (NSString *)agoText:(NSUInteger)sec
{
//    초  	60
//    분 	60 * 60
//    시간   60 * 60 * 24
//    일  	60 * 60 * 24 * 30
//    월  	60 * 60 * 24 * 30 * 12
//    년    이상일 경우
    
    if (sec < 60)
    {
        return [NSString stringWithFormat:@"%lu초 전", (unsigned long)sec];
    }
    else if (sec < 60 * 60)
    {
        return [NSString stringWithFormat:@"%lu분 전", (unsigned long)sec / 60];
    }
    else if (sec < 60 * 60 * 24)
    {
        return [NSString stringWithFormat:@"%lu시간 전", (unsigned long)sec / (60 * 60)];
    }
    else if (sec < 60 * 60 * 24 * 30)
    {
        return [NSString stringWithFormat:@"%lu일 전", (unsigned long)sec / (60 * 60 * 24)];
    }
    else if (sec < 60 * 60 * 24 * 30 * 12)
    {
        return [NSString stringWithFormat:@"%lu달 전", (unsigned long)sec / (60 * 60 * 24 * 30)];
    }

    return [NSString stringWithFormat:@"%lu년 전", (unsigned long)sec / (60 * 60 * 24 * 30 * 12)];
}

- (NSString *)convertNumber:(NSString *)str
{
    CGFloat num = [str floatValue];
    NSString *cNum;
    
    if (num >= 1000.0f && num < 10000.0f)
    {
        cNum = [NSString stringWithFormat:@"%.1fk", num / 1000.0f];
    }
    else if (num >= 10000.0f && num < 1000000.0f)
    {
        cNum = [NSString stringWithFormat:@"%.0fk", num / 1000.0f];
    }
    else if (num >= 1000000.0f && num < 10000000.0f)
    {
        cNum = [NSString stringWithFormat:@"%.1fm", num / 1000000.0f];
    }
    else if (num >= 10000000.0f)
    {
        cNum = [NSString stringWithFormat:@"%.0fm", num / 1000000.0f];
    }
    else
    {
        cNum = str;
    }
    
    return cNum;
}

- (NSString *)stationId:(NSString *)stId 
{
    stId = [stId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSInteger length    = [stId length];
    
//    if (length == 3) 
//    {
//        NSString *strLast        = [stId substringFromIndex:length - 2];
//        NSString *strFirst       = [stId substringToIndex:length - [strLast length]];
//        return [NSString stringWithFormat:@"00%@-%@", strFirst, strLast];
//    }
//    else if (length == 4) 
//    {
//        NSString *strLast        = [stId substringFromIndex:length - 2];
//        NSString *strFirst       = [stId substringToIndex:length - [strLast length]];
//        return [NSString stringWithFormat:@"0%@-%@", strFirst, strLast];
//    }
//    else if (length == 5) 
//    {
//        NSString *strLast        = [stId substringFromIndex:length - 2];
//        NSString *strFirst       = [stId substringToIndex:length - [strLast length]];
//        return [NSString stringWithFormat:@"%@-%@", strFirst, strLast];
//    }
    
    if (length == 3) 
    {
        NSString *strFirst      = [stId substringWithRange:NSMakeRange(0, 2)];
        NSString *strLast       = [stId substringWithRange:NSMakeRange(2, 1)];
        return [NSString stringWithFormat:@"%@-00%@", strFirst, strLast];
    }
    else if (length == 4) 
    {
        NSString *strFirst      = [stId substringWithRange:NSMakeRange(0, 2)];
        NSString *strLast       = [stId substringWithRange:NSMakeRange(2, 2)];
        return [NSString stringWithFormat:@"%@-0%@", strFirst, strLast];
    }
    else if (length == 5) 
    {
        NSString *strFirst      = [stId substringWithRange:NSMakeRange(0, 2)];
        NSString *strLast       = [stId substringWithRange:NSMakeRange(2, 3)];
        return [NSString stringWithFormat:@"%@-%@", strFirst, strLast];
    }
    
    return stId;
}

- (NSString *)blank:(NSUInteger)count
{
    NSMutableString *str = [[NSMutableString alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        [str appendString:@" "];
    }
    
    return str;
}

- (NSString *)toString:(NSArray *)arr key:(NSString *)key
{
    NSMutableString *str = [[NSMutableString alloc] init];
    BOOL isFirst = YES;
    
    for (NSDictionary *dic in arr)
    {
        NSString *val = [dic objectForKey:key];
        
        if (isFirst)
        {
            isFirst = NO;
            [str appendString:val];
        }
        else
        {
            [str appendFormat:@",%@", val];
        }
    }
    
    return str;
}


- (BOOL)saveLocalImage:(UIImage *)image file:(NSString *)fileName
{
//	NSData *data            = UIImagePNGRepresentation(image);
    NSData *data            = UIImageJPEGRepresentation(image, 0.8f);
    
    NSArray *documentPaths	= NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir	= [documentPaths objectAtIndex:0];
    NSString *filePath      = [documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    
	return [data writeToFile:filePath atomically:YES];
}

- (uint64_t)freeDiskspace
{
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    
    __autoreleasing NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", ((totalSpace/1024ll)/1024ll), ((totalFreeSpace/1024ll)/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

- (NSUInteger)versionInt:(NSString *)str
{
    NSArray *ver = [str componentsSeparatedByString:@"."];
    
    if ([ver count] == 0)
    {
        return 0;
    }
    else if ([ver count] == 1)
    {
        return [[ver objectAtIndex:0] intValue] * 10000;
    }
    else if ([ver count] == 2)
    {
        return [[ver objectAtIndex:0] intValue] * 10000 + [[ver objectAtIndex:1] intValue] * 100;
    }
    else if ([ver count] == 3)
    {
        return [[ver objectAtIndex:0] intValue] * 10000 + [[ver objectAtIndex:1] intValue] * 100 + [[ver objectAtIndex:2] intValue];
    }
    
    return 0;
}

- (BOOL)isArrayEmpty:(NSArray *)array
{
    if (array == nil) return FALSE;
    if (![array isKindOfClass:[NSArray class]]) return FALSE;
    
    if ([array count] == 0) return FALSE;
    
    return YES;
}

- (NSDictionary *)dicImageArray:(NSArray *)images forKey:(NSString *)key
{
    for (NSDictionary *dic in images) {
        if(![self isNull:[dic objectForKey:@"image_key"]]) {
            if([[dic objectForKey:@"image_key"] isEqualToString:key]) {
                return dic;
            }
        }
    }
    
    return [images firstObject];
}

- (CGSize)sizeForStickerMaximumImageInDic:(NSDictionary *)dic
{
    CGSize size = CGSizeMake(0, 0);
    
    if (![[Utility sharedUtility] isNull:[dic objectForKey:@"sticker_image_count"]]) {
        if ([[dic objectForKey:@"sticker_image_count"] integerValue] > 0) {
            
            NSArray *stickerImages = [dic objectForKey:@"sticker_images"];
            if ([self isArrayEmpty:stickerImages]) {
                NSDictionary *imageDic = [self dicImageArray:stickerImages forKey:@"sticker"];
                float width = [[imageDic objectForKey:@"image_width"] floatValue];
                float height = [[imageDic objectForKey:@"image_height"] floatValue];
                
                if (size.width < width) {
                    size.width = width;
                }
                
                if (size.height < height) {
                    size.height = height;
                }
            }
        }
    }
    
    return size;
}

- (void)showProgressHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
    });
}

- (void)closeProgressHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

- (void)infoProgressHUD:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:msg];
    });
}

- (void)errorProgressHUD:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:msg];
    });
}

- (void)successProgressHUD:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:msg];
    });
}





- (void)addActivityIndicator:(UIView *)parent
{
    for (UIView *v in parent.subviews)
    {
        if ([v isKindOfClass:[UIActivityIndicatorView class]])
        {
            return;
        }
    }
    
    UIActivityIndicatorView *spinner	= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center						= CGPointMake(parent.frame.size.width / 2, parent.frame.size.height / 2);
    [spinner startAnimating];
    
    [parent addSubview:spinner];
    //	[spinner release];
}

- (void)removeActivityIndicator:(UIView *)parent
{
    for (UIView *v in [parent subviews])
    {
        if ([v class] == [UIActivityIndicatorView class])
        {
            [((UIActivityIndicatorView *)v) performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
            [((UIActivityIndicatorView *)v) performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void)showMessageBox:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Close", nil)
                                          otherButtonTitles:nil];
    //	[alert show];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    //	[alert release];
}

- (void)showMessageBox:(NSString *)msg title:(NSString *)title confirm:(NSString *)confirm
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:confirm
                                          otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
}

- (CGFloat)screenScale
{
    return [UIScreen mainScreen].scale;
}


@end
