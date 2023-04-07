//
//  HULanguageUtils.h
//  HayU
//
//  Created by 呛人的黑 on 2022/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HULanguageInfo : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *tag;
@end

typedef NS_ENUM(NSUInteger, HULanguageSwitchType) {
    HULanguageSwitchType_hans,// 简体中文
    HULanguageSwitchType_en,// 英文
    HULanguageSwitchType_hk,// 香港繁体
    HULanguageSwitchType_tw,// 台湾正体
    HULanguageSwitchType_ar,// 阿拉伯语
    HULanguageSwitchType_tr,// 土耳其语
    HULanguageSwitchType_id,// 印尼语
    HULanguageSwitchType_ms,// 马来语
    HULanguageSwitchType_th,// 泰语
    HULanguageSwitchType_vi,// 越南语
    HULanguageSwitchType_hi,// 印地语
    HULanguageSwitchType_es,// 西班牙语
    HULanguageSwitchType_pt_br,// 葡萄牙语（巴西）
    HULanguageSwitchType_ru, // 俄语
    HULanguageSwitchType_ja, // 日语
    HULanguageSwitchType_fr, // 法语
    HULanguageSwitchType_de, // 德语
    HULanguageSwitchType_ko, // 韩语
    HULanguageSwitchType_it, // 意大利语
};

@interface HULanguageModel : NSObject
/// 语言类型
@property (assign, readonly, nonatomic) HULanguageSwitchType language;
/// 多国语言下的名称
@property (copy, readonly, nonatomic) NSString *name;
/// 语言简写 tag
@property (copy, readonly, nonatomic) NSString *tag;

@property (nonatomic, assign) BOOL isCurrent;

- (instancetype)initWithLanguageType:(HULanguageSwitchType)language;
+ (instancetype)languageWithType:(HULanguageSwitchType)language;
@end


@interface HULanguageUtils : NSObject
/// 获取当前系统语言
+ (NSString *)appleLanguage;
/// 当前语言码，带地区
+ (NSString *)languageCode;
/// 当前语言名称
+ (NSString *)languageName;

/// 当前语言的简写，不带地区
+ (NSString *)languageTag;

/// 是否为 RTL
+ (BOOL)isRTL;
/// 所有支持的语言模型
+ (NSArray <HULanguageModel *>*_Nonnull)all;
/// 当前所支持类型 中，英，阿拉伯语
+ (NSArray <HULanguageModel *>*_Nonnull)hayuLanguage;

/// 更新语言码
/// @param code 语言简写
//+ (void)updateLanguageWithCode:(NSString *)code;

@end

NS_ASSUME_NONNULL_END
