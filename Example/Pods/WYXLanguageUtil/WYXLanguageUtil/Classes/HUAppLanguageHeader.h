//
//  HUAppLanguageHeader.h
//  HayU
//
//  Created by 呛人的黑 on 2022/12/3.
//

#ifndef HUAppLanguageHeader_h
#define HUAppLanguageHeader_h

typedef NS_ENUM(NSUInteger, HUAppLanguage) {
    HUAppLanguage_followSystem = 0,           ///未知，跟随系统语言。
    HUAppLanguage_en=1,                       ///英语
    HUAppLanguage_zh_Hans=2,                  ///中文简体
    HUAppLanguage_zh_Hant=3,                  ///中文繁体
    HUAppLanguage_zh_Hant_HK=4,               ///中文繁体,香港
    HUAppLanguage_vi=5,                       ///越南语
    HUAppLanguage_ko=6,                       ///韩语
    HUAppLanguage_ja=7,                       ///日语
    HUAppLanguage_ar=8,                       ///阿拉伯语
    HUAppLanguage_pt=9,                       ///葡萄牙语
    HUAppLanguage_ru=10,                      ///俄罗斯
    HUAppLanguage_fr=11,                       ///法语
    HUAppLanguage_id=12,                       ///印尼语
    HUAppLanguage_es=13,                       ///西班牙语
    HUAppLanguage_ms=14,                       ///马来西亚文
    HUAppLanguage_th=15,                        ///泰语
    HUAppLanguage_tr=16,                        ///土耳其语
    HUAppLanguage_ta=17,                        ///泰米尔语
    HUAppLanguage_te=18,                        ///泰卢固语
    HUAppLanguage_bn=19,                        ///孟加拉语
    HUAppLanguage_gu=20,                        ///古吉拉特语
    HUAppLanguage_mr=21,                        ///马拉提语
    HUAppLanguage_hi=22,                        ///印地语
    HUAppLanguage_ur=23,                        ///乌尔都语
    HUAppLanguage_de=24,                        ///德语
};

#pragma mark -
#pragma mark - LangaugeOfCountry

//简体中文
static NSString * const HULanguageFollowSystem            = @"system";

///多语言UserDefaHUt中key
static NSString * const HUUserDefaHUtAppLanguage         = @"appLanguage";
///"AR" 指 中东地区
static NSString * const HUCountryCodeMiddelEastKey       = @"AR";
///中国的国家码
static NSString * const HUCountryCodeChina               = @"CN";
///中文[大中华区]
static NSString * const HULanguageChina                  = @"zh";
//简体中文
static NSString * const HULanguageChina_Hans             = @"zh-Hans";
//繁体中文
static NSString * const HULanguageChina_Hant             = @"zh-Hant";
//繁体中文,香港
static NSString * const HULanguageChina_Hant_HK          = @"zh-Hant-HK";
// 台湾正体
static NSString * const HULanguagezh_Hant_TW         = @"zh-Hant-TW";
///英语[英语世界]
static NSString * const HULanguageEnglish                = @"en";
///越南语[交趾郡]
static NSString * const HULanguageVietnam                = @"vi";
///日语[东瀛.扶桑]
static NSString * const HULanguageJapan                  = @"ja";
///阿拉伯语[中东世界]
static NSString * const HULanguageArabia                 = @"ar";
///葡萄牙语[葡萄牙]
static NSString * const HULanguagePT                     = @"pt";
/// 葡萄牙语（巴西）
static NSString * const HULanguagePT_BR                     = @"pt-BR";

///俄罗斯语[罗刹国]
static NSString * const HULanguageRussia                 = @"ru";
///法语[加拿大]
static NSString * const HULanguageFrance                 = @"fr";
///韩国语[韩国]
static NSString * const HULanguageKorea                  = @"HUo";
///印尼语[印度尼西亚]
static NSString * const HULanguageIndonesian             = @"id";
///西班牙语
static NSString * const HULanguageSpanish                = @"es";
///马来西亚文
static NSString * const HULanguageMalay                  = @"ms";
///泰语
static NSString * const HULanguageThai                   = @"th";
///土耳其语
static NSString * const HULanguageTurkish                = @"tr";
///泰米尔语
static NSString * const HULanguageTamil                  = @"ta";
///泰卢固语
static NSString * const HULanguageTelugu                = @"te";
///孟加拉语
static NSString * const HULanguageBengali                = @"bn";
///古吉拉特语
static NSString * const HULanguageGujarati                = @"gu";
///马拉提语
static NSString * const HULanguageMarathi                = @"mr";
///印地语
static NSString * const HULanguageHindi                = @"hi";
///乌尔都语
static NSString * const HULanguageUrdu                = @"ur";
///德语
static NSString * const HULanguageGerman                = @"de";

static NSString * const HULanguageItaly              = @"it";


#endif /* HUAppLanguageHeader_h */
