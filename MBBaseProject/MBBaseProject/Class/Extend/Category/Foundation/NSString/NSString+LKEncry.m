//
//  NSString+LKEncry.m
//  MD5 加密
//
//  Created by yunjing on 2017/2/21.
//  Copyright © 2017年 yunjing. All rights reserved.
//

#import "NSString+LKEncry.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LKEncry)

+ (NSString *)stringWithMD5:(NSString *)str {
    
    if(str == nil || [str length] == 0)return nil;
    const char *value = [str UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

+ (NSString *)luckyKingEncryptionWithString:(NSString *)string {
    NSString *mark = [string substringWithRange:NSMakeRange(7, 1)];
    NSString *strMD5 = [[NSString alloc] init];
    if ([mark isEqualToString:@"1"] || [mark isEqualToString:@"5"] || [mark isEqualToString:@"9"]) {
        NSString *str1 = [string substringWithRange:NSMakeRange(0, 3)];
        NSString *str2 = [string substringWithRange:NSMakeRange(3, 8)];
        NSString *newStr = [NSString stringWithFormat:@"%@%@%@%@",@"double",str1,@"double",str2];
        strMD5 = [self stringWithMD5:newStr];
    }else if ([mark isEqualToString:@"2"] || [mark isEqualToString:@"6"] || [mark isEqualToString:@"0"]) {
        NSString *str1 = [string substringWithRange:NSMakeRange(0, 2)];
        NSString *str2 = [string substringWithRange:NSMakeRange(2, 6)];
        NSString *str3 = [string substringWithRange:NSMakeRange(8, 3)];
        NSString *newStr = [NSString stringWithFormat:@"%@%@%@%@%@",str1,@"double",str2,@"SxLuCKYkING",str3];
        strMD5 = [self stringWithMD5:newStr];
    }else if ([mark isEqualToString:@"3"] || [mark isEqualToString:@"7"]) {
        NSString *str1 = [string substringWithRange:NSMakeRange(0, 5)];
        NSString *str2 = [string substringWithRange:NSMakeRange(5, 6)];
        NSString *newStr = [NSString stringWithFormat:@"%@%@%@%@%@",@"DOUBLE",str1,@"DOUble",str2,@"double"];
        strMD5 = [self stringWithMD5:newStr];
    } else {
        NSString *newStr = [NSString stringWithFormat:@"%@%@%@",@"SXLUCKYKING",string,@"sxluckyking"];
        strMD5 = [self stringWithMD5:newStr];
    }
    
    return strMD5;
}

+ (NSDictionary *)generateArguments:(NSDictionary *)arguments {
    
    return [self encryptionArguments:arguments saltVal:YES];
}

+ (NSDictionary *)generatePartArguments:(NSDictionary *)arguments {
    
    return [self encryptionArguments:arguments saltVal:NO];
}



/** 生成MD5 加密接口 */
+ (NSDictionary *)encryptionArguments:(NSDictionary *)arguments saltVal:(BOOL)saltVal {
    
    if (!arguments || arguments.allKeys.count == 0) {
        return arguments;
    }
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:arguments];
    
    // $timeStap$randmonStr
    NSString *timeStamp = [self getTimeStap];
    NSString *randomStr = [self getRandomStr];
    
    dictM[@"timestampVal"] = timeStamp;
    dictM[@"randomVal"] = randomStr;
    if (saltVal) {
        dictM[@"saltVal"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"MD5_SALT"];
        
    } else {
        dictM[@"saltVal"] = @"sxluckyking";
    }
    
    NSString *md5Str = @"";
    
    NSMutableArray *arr = [NSMutableArray array];
    
    // 转小写
    __weak __typeof(self)weakSelf = self;
    NSMutableDictionary *lowDictM = [NSMutableDictionary dictionary];
    [dictM.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *lowStr = [weakSelf toLower:obj];
        lowDictM[lowStr] = obj;
        [arr addObject:lowStr];
    }];
    
    // 排序
    NSArray *sortArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];;
    }];
    
    arr = [NSMutableArray arrayWithArray:sortArr];
    
    for (NSString *key in arr) {
        NSString *value = dictM[lowDictM[key]];
        
        //NSLog(@"%@", value);
        if ([value stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
            [dictM removeObjectForKey:key];
            continue;
        }
        
        if (md5Str.length != 0) {
            md5Str = [md5Str stringByAppendingString:@"&"];
        }
        
        md5Str = [md5Str stringByAppendingString:key];
        md5Str = [md5Str stringByAppendingString:@"="];
        md5Str = [md5Str stringByAppendingString:value];
    }
    
    md5Str = [self encryptToMD5WithString:md5Str];
    
    dictM[@"md5Val"] = md5Str;
    
    [dictM removeObjectForKey:@"saltVal"];
    return dictM;
    
}

/** 获取当前时间戳 */
+ (NSString *)getTimeStap {
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval timInterval = [dat timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", timInterval];
    
    return timeString;
    
}

/** 获取6为随机数 */
+ (NSString *)getRandomStr {
    int num = (arc4random() % 1000000);
    NSString *randomNumber = [NSString stringWithFormat:@"%.6d", num];
    
    return randomNumber;
    
}

/** 转小写 */
+ (NSString *)toLower:(NSString *)str{
    for (NSInteger i=0; i<str.length; i++) {
        if ([str characterAtIndex:i]>='A'&[str characterAtIndex:i]<='Z') {
            //A  65  a  97
            char  temp=[str characterAtIndex:i]+32;
            NSRange range=NSMakeRange(i, 1);
            str=[str stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}

/** MD5 加密 */
+ (NSString *)encryptToMD5WithString:(NSString *)originalStr {
    return [self stringWithMD5:originalStr];
}

+ (BOOL)validateNeedSaltValue:(NSString *)url {
    NSArray *ignore = @[@"regist", @"login", @"updatePwd"];
    if ([ignore containsObject:url.lastPathComponent]) {
        return NO;
    } else {
        return YES;
    }
}
@end
