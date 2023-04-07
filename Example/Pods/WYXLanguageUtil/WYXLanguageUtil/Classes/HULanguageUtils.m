//
//  HULanguageUtils.m
//  HayU
//
//  Created by 呛人的黑 on 2022/12/3.
//

#import "HULanguageUtils.h"
#import "HUAppLanguageHeader.h"

#define HUUserLanguageKey @"hayu.UserLanguageKey"

@implementation HULanguageInfo
@end

@implementation HULanguageModel

- (instancetype)initWithLanguageType:(HULanguageSwitchType)language {
    self = [super init];
    if (self) {
        _language = language;
        HULanguageInfo *info = [self tagWithLanguage:language];
        _tag = info.tag;
        _name = info.name;
        if ([[HULanguageUtils languageTag] containsString:info.tag]) {
            _isCurrent = YES;
        }
    }
    return self;
}
 
+ (instancetype)languageWithType:(HULanguageSwitchType)language {
    return [[self alloc] initWithLanguageType:language];
}

- (HULanguageInfo *)tagWithLanguage:(HULanguageSwitchType)language {
    HULanguageInfo *info = [HULanguageInfo new];
    switch (language) {
        case HULanguageSwitchType_hans:
        {
            info.name = @"简体中文";
            info.tag = HULanguageChina_Hans;
            return info;
        }
            break;
        case HULanguageSwitchType_en:
        {
            info.name = @"English";
            info.tag = HULanguageEnglish;
            return info;
        }
            break;
        case HULanguageSwitchType_hk:
        {
            info.name = @"繁體中文(香港)";
            info.tag = HULanguageChina_Hant_HK;
            return info;
        }
            break;
        case HULanguageSwitchType_tw:
        {
            info.name = @"台灣正體";
            info.tag = HULanguagezh_Hant_TW;
            return info;
        }
            break;
        case HULanguageSwitchType_ar:
        {
            info.name = @"العربية";
            info.tag = HULanguageArabia;
            return info;
        }
            break;
        case HULanguageSwitchType_tr:
        {
            info.name = @"Türkçe";
            info.tag = HULanguageTurkish;
            return info;
        }
            break;
        case HULanguageSwitchType_id:
        {
            info.name = @"Bahasa Indonesia";
            info.tag = HULanguageIndonesian;
            return info;
        }
            break;
        case HULanguageSwitchType_ms:
        {
            info.name = @"Bahasa Malaysia";
            info.tag = HULanguageMalay;
            return info;
        }
            break;
        case HULanguageSwitchType_th:
        {
            info.name = @"Türkçe";
            info.tag = HULanguageThai;
            return info;
        }
            break;
        case HULanguageSwitchType_vi:
        {
            info.name = @"Tiếng việt";
            info.tag = HULanguageVietnam;
            return info;
        }
            break;
        case HULanguageSwitchType_hi:
        {
            info.name = @"हिंदी";
            info.tag = HULanguageHindi;
            return info;
        }
            break;
        case HULanguageSwitchType_es:
        {
            info.name = @"Español";
            info.tag = HULanguageSpanish;
            return info;
        }
            break;
        case HULanguageSwitchType_pt_br:
        {
            info.name = @"Português";
            info.tag = HULanguagePT_BR;
            return info;
        }
            break;
        case HULanguageSwitchType_ru:
        {
            info.name = @"Pусский";
            info.tag = HULanguageRussia;
            return info;
        }
            break;
        case HULanguageSwitchType_ja:
        {
            info.name = @"日本語";
            info.tag = HULanguageJapan;
            return info;
        }
            break;
        case HULanguageSwitchType_fr:
        {
            info.name = @"Français";
            info.tag = HULanguageFrance;
            return info;
        }
            break;
        case HULanguageSwitchType_de:
        {
            info.name = @"Deutsch";
            info.tag = HULanguageGerman;
            return info;
        }
            break;
        case HULanguageSwitchType_ko:
        {
            info.name = @"한국어";
            info.tag = HULanguageKorea;
            return info;
        }
            break;
        case HULanguageSwitchType_it:
        {
            info.name = @"Italiano";
            info.tag = HULanguageItaly;
            return info;
        }
            break;
        default:
            NSAssert(false, @"----未加入的类型 %lu", (unsigned long)language);
            return info;
            break;
    }
}

@end

@implementation HULanguageUtils
/// 获取当前系统语言
+ (NSString *)appleLanguage {
    NSArray *allLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *curLanguage = [allLanguages objectAtIndex:0];
    return curLanguage;
}

/// 当前系统语言转语言码
+ (NSString *)languageCode {
    NSString *curLanguage = nil;
    NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:HUUserLanguageKey];
    if (code && code.length > 0) {
        curLanguage = code;
    } else {
        curLanguage = [self appleLanguage];
    }
    
    NSString *returnLanguage = @"";
    // 中文简体
    if ([curLanguage hasPrefix:HULanguageChina_Hans]) {
        returnLanguage = @"zh-CN";
    }
    // 中文繁体
    else if ([curLanguage hasPrefix:@"zh-"]) {
        if ([curLanguage hasPrefix:@"zh-Hant-HK"]) {
            returnLanguage = @"zh-HK";
        } else {
            returnLanguage = @"zh-TW";
        }
    }
    // 越南语
    else if ([curLanguage hasPrefix:HULanguageVietnam]) {
        returnLanguage = @"vi-VN";
    }
    // 日语
    else if ([curLanguage hasPrefix:HULanguageJapan]) {
        returnLanguage = @"ja-JP";
    }
    // 阿拉伯语
    else if ([curLanguage hasPrefix:HULanguageArabia]) {
        returnLanguage = @"ar-EG";
    }
    // 葡萄牙语
    else if ([curLanguage hasPrefix:HULanguagePT]) {
        returnLanguage = @"pt-PT";
    }
    // 俄罗斯语
    else if ([curLanguage hasPrefix:HULanguageRussia]) {
        returnLanguage = @"ru-RU";
    }
    // 法语
    else if ([curLanguage hasPrefix:HULanguageFrance]) {
        returnLanguage = @"fr-FR";
    }
    // 韩语
    else if ([curLanguage hasPrefix:HULanguageKorea]) {
        returnLanguage = @"ko-KR";
    }
    // 印尼语
    else if ([curLanguage hasPrefix:HULanguageIndonesian]) {
        returnLanguage = @"id-ID";
    }
    // 印度语
    else if ([curLanguage hasPrefix:HULanguageHindi]) {
        returnLanguage = @"hi-IN";
    }
    // 西班牙语
    else if ([curLanguage hasPrefix:HULanguageSpanish]) {
        returnLanguage = @"es-ES";
    }
    // 马来西亚文
    else if ([curLanguage hasPrefix:HULanguageMalay]) {
        returnLanguage = @"ms-MY";
    }
    // 泰语
    else if ([curLanguage hasPrefix:HULanguageThai]) {
        returnLanguage = @"th-TH";
    }
    // 土耳其语
    else if ([curLanguage hasPrefix:HULanguageTurkish]) {
        returnLanguage = @"tr-TR";
    }
    // 孟加拉语（Bengali）bn
    else if ([curLanguage hasPrefix:HULanguageBengali]) {
        curLanguage = @"bn-IN";
    }
    // 马拉提语（Marathi）mr
    else if ([curLanguage hasPrefix:HULanguageMarathi]) {
        curLanguage = @"mr-IN";
    }
    // 古吉拉特语（Gujarati）gu
    else if ([curLanguage hasPrefix:HULanguageGujarati]) {
        curLanguage = @"gu-IN";
    }
    // 泰米尔语（Tamil）ta
    else if ([curLanguage hasPrefix:HULanguageTamil]) {
        curLanguage = @"ta-IN";
    }
    // 泰卢固语（Telugu）te
    else if ([curLanguage hasPrefix:HULanguageTelugu]) {
        curLanguage = @"te-IN";
    }
    // 乌尔都语（Urdu）ur
    else if ([curLanguage hasPrefix:HULanguageUrdu]) {
        curLanguage = @"ur-IN";
    }
    // 默认英语
    else {
        returnLanguage = @"en-US";
    }
    return returnLanguage;
}

/// 当前语言名称
+ (NSString *)languageName {
    __block NSString *name = nil;
    [[HULanguageUtils all] enumerateObjectsUsingBlock:^(HULanguageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[self languageTag] containsString:obj.tag]) {
            name = obj.name;
            *stop = YES;
        }
    }];
    return name;
}

+ (NSString *)languageTag {
    NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:HUUserLanguageKey];
    if (code && code.length > 0) {
        return code;
    } else {
        return [NSLocale preferredLanguages].firstObject;
    }
}

/// 更新语言码
/// @param code 语言简写
//+ (void)updateLanguageWithCode:(NSString *)code {
//    [[NSUserDefaults standardUserDefaults] setObject:code forKey:kUserLanguageKey];
//    AppDelegate *delegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
//    [delegate setContentAttribute];
//    [[NSNotificationCenter defaultCenter] postNotificationName:VIEW_CONTENTATTRIBUTE_NOTIFICATION_KEY object:nil];
//}

/// 是否为 RTL
+ (BOOL)isRTL {
    NSString *language = [self languageCode];
    return ([language hasPrefix:@"ar"] || // 阿拉伯语
            [language hasPrefix:@"fa"] || // 波斯语
            [language hasPrefix:@"iw"] || // 希伯来语
            [language hasPrefix:@"ur"]);  // 乌尔都语（印度、巴基斯坦）
}

+ (NSArray <HULanguageModel *>*_Nonnull)all {
    NSArray *allItems = @[@(HULanguageSwitchType_hans),
                          @(HULanguageSwitchType_hk),
                          @(HULanguageSwitchType_tw),
                          @(HULanguageSwitchType_en),
                          @(HULanguageSwitchType_ja),
                          @(HULanguageSwitchType_ar),
                          @(HULanguageSwitchType_vi),
                          @(HULanguageSwitchType_ru),
                          @(HULanguageSwitchType_pt_br),
                          @(HULanguageSwitchType_fr),
                          @(HULanguageSwitchType_ko),
                          @(HULanguageSwitchType_id),
                          @(HULanguageSwitchType_ms),
                          @(HULanguageSwitchType_th),
                          @(HULanguageSwitchType_tr),
                          @(HULanguageSwitchType_hi),
                          @(HULanguageSwitchType_es),
                          @(HULanguageSwitchType_de),
                          @(HULanguageSwitchType_it)];
    NSMutableArray *allLanugages = [NSMutableArray array];
    [allItems enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HULanguageModel *model = [HULanguageModel languageWithType:[obj intValue]];
        [allLanugages addObject:model];
    }];
    return [allLanugages copy];
}

+ (NSArray <HULanguageModel *>*_Nonnull)hayuLanguage {
    NSArray *allItems = @[@(HULanguageSwitchType_hans),
                          @(HULanguageSwitchType_en),
                          @(HULanguageSwitchType_ar),
                          @(HULanguageSwitchType_es)];
    NSMutableArray *allLanugages = [NSMutableArray array];
    [allItems enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HULanguageModel *model = [HULanguageModel languageWithType:[obj intValue]];
        [allLanugages addObject:model];
    }];
    return [allLanugages copy];
}
@end
