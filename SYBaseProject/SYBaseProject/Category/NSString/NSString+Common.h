//
//  NSString+Common.h
//  MIX-Token
//
//  Created by mix on 2018/4/25.
//  Copyright © 2018年 mix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)
/** 字符串去掉空格 */
+ (NSString *)stringWithOutSpace:(NSString *)str;

/** 字符串去掉空格和换行 */
+ (NSString *)stringOutSpaceAndEnter:(NSString*)str;

/** 保证输入金额的有效性 */
+ (BOOL) isFloatData:(NSString *)data;
/** 判读邮箱 */
+ (BOOL)isValidateEmail:(NSString *)Email;
/** 判读邮政编码 */
+ (BOOL) isValidatePostCode:(NSString *) postCode;
/** 判断电话号码 */
+ (BOOL) isValidateMobile:(NSString *)mobileNum;
/** 判断是否数字 */
+ (BOOL) isValidateNumber:(NSString *)number;
/** 验证密码 */
+ (BOOL) isValidatePwd:(NSString *)pwd;
/** 身份证号 --不使用！采用MobAPI */
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard;
/** 判断是否为整形 */
+ (BOOL)isPureInt:(NSString*)string;
/** 判断是否为浮点形 */
+ (BOOL)isPureFloat:(NSString*)string;
/** 获取视图的上层的视图控制器 */
+ (UIViewController*)superViewController:(UIView *)view;
/** 大写转小写 */
+ (NSString *)TurnUppercaseLowercase:(NSString *)str;
/** 检测密码时候包含特殊字符 */
+(BOOL)isIncludeSpecialCharact: (NSString *)str;
/** 判断两个字符串是否相等<不区分大小写> */
+ (BOOL) towStringIsEqual:(NSString *)str1 Str2:(NSString *)str2;
/** 将字符串进行Unicode编码(只对中文进行编码) */
+ (NSString *)chinaToUnicode:(NSString *)str;
/** md5加密 */
+ (NSString *)md5HexDigest:(NSString*)input;
/** 转json字符串 */
+ (NSString*)DataTOjsonString:(NSDictionary*)params;
/** 获取当前的网络状态 */
+ (NSInteger)getCurrageNetWorkStatus;
/** 中文转拼音 */
+ (NSString *)transformToPinyin:(NSString*)chinese;
/** 设置不同字体和颜色 */
+ (void)fwbLabel:(UILabel*)LB FontNumber:(id)font FirstStr:(NSString*)firstStr  LastStr:(NSString*)lastStr AndColor:(UIColor *)color;
/** 按照中文两个字符，英文数字一个字符计算字符数*/
+ (NSUInteger) unicodeLengthOfString: (NSString *) text;
/** 判断是否为中文 */
+ (BOOL)isChinese:(NSString *)str;

/***  判断当前时间是否处于某个时间段内*/
+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime;
/** 判断时间还未开始 */
+ (BOOL)unBeginWithStartTime:(NSString *)startTime;
/** 判断是否已经结束 */
+ (BOOL)endWithExpireTime:(NSString *)expireTime;
/** 判断是否和当前时间一致 */
+ (BOOL)sameWithExpireTime:(NSString *)expireTime;
/** 比较两个时间 -1后者大 ，0 相同 ，1 前者大*/
+ (NSInteger)compareTimeWithStartTime:(NSString *)startTime ExpireTime:(NSString *)expireTime;

/**将时间戳(秒)按时间格式转成时间字符串*/
+ (NSString*)timintervalToTimeStr:(NSString*)dateFormatStr timeInterval:(NSInteger)secondValue;

/**
 * 计算文字高度，可以处理计算带行间距的等属性
 */
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font;
/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;
/**
 * 计算最大行数文字高度，可以处理计算带行间距的
 */
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines;

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;
/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)jk_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)jk_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)jk_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)jk_sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief  反转字符串
 *
 *  @param strSrc 被反转字符串
 *
 *  @return 反转后字符串
 */
+ (NSString *)jk_reverseString:(NSString *)strSrc;



//浮点数处理并去掉多余的0
+(NSString *)stringDisposeWithStr:(NSString*)str;



/**
 @param str 字符串
 @param lineSpace 行间距
 @return 返回富文本字符串
 */
+ (NSMutableAttributedString*)attributeWithStr:(NSString*)str  lineSpace:(CGFloat)lineSpace;
//2种颜色的字符
+(NSMutableAttributedString *)getAttributeStr:(NSString *)text topLength:(CGFloat)topLength topColor:(UIColor *)topColor afterLength:(CGFloat)afterLength afterColor:(UIColor *)afterColor topFont:(UIFont *)topFont afterFont:(UIFont *)afterFont;

//
+ (NSString*)arrayToJSONString:(NSArray *)array;

//字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (NSArray *)jsonStrToArray:(NSString *)jsonStr;

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString*)dateStringBytimeStampString;



@end
