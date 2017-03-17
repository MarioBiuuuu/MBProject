//
//  LKCommonTools.m
//  DDDDD
//
//  Created by Yuri on 16/8/30.
//  Copyright © 2016年 Yuri. All rights reserved.
//

#import "LKCommonTools.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>


#define DefaultThumImageHigth 90.0f
#define DefaultPressImageHigth 960.0f

NSString *const kSandeBoxUserName = @"systemUserName";
NSString *const kSandeBoxUserMobile = @"systemUserMobile";
NSString *const kSandeBoxUserID = @"systemUserID";
NSString *const kSandeBoxUserInfo = @"systemUserInfo";

@implementation LKCommonTools

+(BOOL)judgePhoneNumberIsLegal:(NSString *)phoneNumber {
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|7[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU =@"^1((33|53|81|82|8[09])[0-9]|0123456789)\\d{7}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phoneNumber] == YES)
        || ([regextestcm evaluateWithObject:phoneNumber] == YES)
        || ([regextestct evaluateWithObject:phoneNumber] == YES)
        || ([regextestcu evaluateWithObject:phoneNumber] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSDictionary *)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    __block NSUInteger emojiCount = 0;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                            emojiCount += 1;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                        emojiCount += 1;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                        emojiCount += 1;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                        emojiCount += 1;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                        emojiCount += 1;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                        emojiCount += 1;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                        emojiCount += 1;
                                    }
                                }
                            }];
    NSDictionary *dict = @{@"isContains":@(returnValue), @"emojiCount":@(emojiCount)};
    return dict;
}

+ (NSString *)translateChineseToPinYin:(NSString *)string {
    NSMutableString *pinyin = [string mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin uppercaseString];
}

+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

+ (NSString*)dictionaryToJson:(id)object {
    NSString *jsonString = [[NSString alloc]init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
//    NSRange range = {0,jsonString.length};
//    [mutStr replaceOccurrencesOfString:@" "withString:@""options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    [mutStr replaceOccurrencesOfString:@"\n"withString:@""options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSDictionary *)JsonToDictionary:(NSString *)string {
    if (string == nil) {
        return nil;
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (UIImage *)compressImage:(UIImage *)image withSize:(CGSize)viewSize {
    CGFloat imgHWScale = image.size.height/image.size.width;
    CGFloat viewHWScale = viewSize.height/viewSize.width;
    CGRect rect = CGRectZero;
    
    if (imgHWScale>viewHWScale) {
        rect.size.height = viewSize.width*imgHWScale;
        rect.size.width = viewSize.width;
        rect.origin.x = 0.0f;
        rect.origin.y =  (viewSize.height - rect.size.height)*0.5f;
    } else {
        CGFloat imgWHScale = image.size.width/image.size.height;
        rect.size.width = viewSize.height*imgWHScale;
        rect.size.height = viewSize.height;
        rect.origin.y = 0.0f;
        rect.origin.x = (viewSize.width - rect.size.width)*0.5f;
    }
    
    UIGraphicsBeginImageContext(viewSize);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newimg;
}

+ (UIColor *)getColorWithMobile:(NSString *)mobile {
    if (mobile.length >= 11 && ![mobile isEqualToString:@"(null)"]) {
        NSString *telephone = mobile;
        
        CGFloat r = 0.0,g = 0.0,b = 0.0;
        
        r = [self caculateWithNum:[[telephone substringToIndex:4] intValue] % 255 / 255.0];
        g = [self caculateWithNum:[[telephone substringWithRange:NSMakeRange(4, 4)] intValue] % 255 / 255.0];
        b = [self caculateWithNum:[[telephone substringFromIndex:8] intValue] % 255 / 255.0];
        UIColor *color = [UIColor colorWithRed:r green:g  blue:b alpha:1.0];
        return color;
    }else {
        return [UIColor blueColor];
    }
}

+ (CGFloat)caculateWithNum:(CGFloat)num {
    if (80.0 < num < 200.0) {
        return num;
    } else {
        if (num > 200.0) {
            return 205.f;
        }
        if (num < 80.0) {
            return 80.0;;
        }
    }
    return 0.0;
}

+ (void)archiveUserMobileToSandBox:(NSString *)mobile {
    [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:kSandeBoxUserMobile];
}

+ (NSString *)unArchiveUserMobile {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSandeBoxUserMobile];
}

+ (void)archiveUserNameToSandBox:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:kSandeBoxUserName];
}

+ (NSString *)unArchiveUserName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSandeBoxUserName];
}

+ (void)archiveUserIDToSandBox:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kSandeBoxUserID];
}

+ (NSString *)unArchiveUserID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kSandeBoxUserID];
}

+ (void)archiveUserInfoToSandBox:(id)userInfoModel {
    NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:userInfoModel];
    [[NSUserDefaults standardUserDefaults] setObject:infoData forKey:kSandeBoxUserInfo];
}

+ (instancetype)unArchiveUserInfo {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kSandeBoxUserInfo]];
}

+ (NSString *)saveImageToDocument:(UIImage *)image {
    [self makeDirToDoucument];
    UIImage *fixImage = [self fixOrientation:image];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *fileName =[NSString stringWithFormat:@"image/j%@.jpg", [formater stringFromDate:[NSDate date]]];
    
    NSString *filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    CGSize pressSize = CGSizeMake((DefaultPressImageHigth/fixImage.size.height) * fixImage.size.width, DefaultPressImageHigth);
    UIImage *pressImage = [self compressImage:fixImage withSize:pressSize];
    NSData *imageData = UIImageJPEGRepresentation(pressImage, 0.6);
    [imageData writeToFile:filePath atomically:YES];

    return filePath;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform     // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,CGImageGetBitsPerComponent(aImage.CGImage), 0,CGImageGetColorSpace(aImage.CGImage),CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:              CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);              break;
    }       // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (void)makeDirToDoucument {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/Image", pathDocuments];
    
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
        NSLog(@"FileDir is exists.");
    }
}

+ (BOOL)checkIsChineseString:(NSString *)checkString {
    
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"(nil)"]) {
        return YES;
    }
    if ([string isEqualToString:@"(NULL)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([string isEqualToString:@"<nil>"]) {
        return YES;
    }
    if ([string isEqualToString:@"<NULL>"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isNumText:(NSString *)str {
    NSString * regex = @"^[0-9]+$";
    NSPredicate * pred  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch  = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}

+ (UIImage *)stretchableImage:(UIImage *)image {
    NSInteger width = image.size.width/2;
    NSInteger height = image.size.width/2;
    
    UIImage *newImage = [image resizableImageWithCapInsets:UIEdgeInsetsMake(height, width, height, width) resizingMode:UIImageResizingModeStretch];
    
    return newImage;
}

#pragma mark - 时间差
+ (BOOL)isLessThanDestMinutes:(double)minutes fromDate:(NSString *)date otherDate:(NSString *)otherDate {
    
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *date1 = [fmt dateFromString:date];
    NSDate *date2 = [fmt dateFromString:otherDate];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [calendar components:unitFlags fromDate:date2 toDate:date1 options:0];
    
    NSInteger totalSecond = [d hour]*3600+[d minute]*60+[d second];
    
    if (totalSecond > minutes * 60.0) {
        return NO;
    }
    else{
        return YES;
    }
}

+ (BOOL)checkBankCardNo:(NSString *)cardNo {
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNo length];
    int lastNum = [[cardNo substringFromIndex:cardNoLength-1] intValue];
    
    cardNo = [cardNo substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNo substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0) {
        return YES;
    } else {
        return NO;
    }
}

///////////////////////////// 正则表达式相关  ///////////////////////////////
- (BOOL)isValidateWithRegex:(NSString *)regex {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pre evaluateWithObject:self];
}

+ (NSString *)getCurrentDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:date];
    return nowtimeStr;
}
+ (NSString *)getCurrentDateString {

    NSString *string = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]*1000 + 0];
    NSString *dateString = [[string componentsSeparatedByString:@"."]objectAtIndex:0];
    return dateString;
}

+ (NSString *)getInternetDate
{
    NSString *urlString = @"http://m.baidu.com";
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    
    // 实例化NSMutableURLRequest，并进行参数配置
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString: urlString]];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [request setTimeoutInterval: 2];
    
    [request setHTTPShouldHandleCookies:FALSE];
    
    [request setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request
     
                          returningResponse:&response error:&error];
    
    // 处理返回的数据
    
    if (error) {
        return [LKCommonTools getCurrentDateString];
    }
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    
    date = [date substringFromIndex:5];
    
    date = [date substringToIndex:[date length]-4];
    
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60 * 60 * 8];
    
    NSString *string = [NSString stringWithFormat:@"%f", [netDate timeIntervalSince1970] * 1000 + 1];
    
    NSString *dateString = [[string componentsSeparatedByString:@"."] objectAtIndex:0];
    
    return dateString;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ref =  UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  image;
}

@end
