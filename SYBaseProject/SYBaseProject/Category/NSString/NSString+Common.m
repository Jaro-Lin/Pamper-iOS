//
//  NSString+Common.m
//  MIX-Token
//
//  Created by mix on 2018/4/25.
//  Copyright © 2018年 mix. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/message.h>

@implementation NSString (Common)

//判断字符串是否包含中文
+ (BOOL) containtChinese:(NSString *) str{
    NSString *patternStr = @".*[\u4e00-\u9fa5].*";
    NSPredicate *chineseTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",patternStr];
    return [chineseTest evaluateWithObject:str];
}


//将字符串进行Unicode编码
+ (NSString *)chinaToUnicode:(NSString *)str{
    
    if ([self containtChinese:str]) {
        NSUInteger length = [str length];
        NSMutableString *result = [NSMutableString stringWithCapacity:0];
        
        for (int i = 0;i < length; i++)
        {
            int _char = [str characterAtIndex:i];
            // 汉字范围 \u4e00-\u9fa5 (中文)
            if (_char >= 19968 && _char <= 171941) {
                [result appendFormat:@"\\u%x",[str characterAtIndex:i]];//转16进制
            }else{
                [result appendFormat:@"%c",[str characterAtIndex:i]];
            }
        }
        return result;
    }else{
        return str;
    }
}



#pragma mark- md5 32位 加密
+ (NSString *)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];

      unsigned char result[CC_MD2_DIGEST_LENGTH];

      CC_MD5(str, (CC_LONG)strlen(str), result);

      NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];

      for(int i = 0; i<CC_MD2_DIGEST_LENGTH;i++){

        [ret appendFormat:@"%02x",result[i]];

      }

    return ret;
}

#pragma mark- 转json字符串
+ (NSString*)DataTOjsonString:(NSDictionary*)params
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    if (! jsonData) {
    }else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
    //
    //    //先检查参数的格式,是否带有对象
    //    BOOL objecInParams = NO;
    //    for (id val in params.allValues) {
    //        if ([val isKindOfClass:[NSDictionary class]] || [val isKindOfClass:[NSArray class]]) {//表示参数中带有直接传字典或数组的对象
    //            objecInParams = YES;
    //            break;
    //        }
    //    }
    //
    //    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:NULL];
    //
    //    if (objecInParams) {
    //        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    }else{
    //        NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        NSString *jsonString = [dataStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    //        return jsonString;
    //    }
}

#pragma mark- 获取当前的网络状态
+ (NSInteger)getCurrageNetWorkStatus{
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"] subviews];
    NSInteger type = 0;
    for (id child in children) {
        if ([child isKindOfClass:
             NSClassFromString(@"UIStatusBarDataNetworkItemView")]){
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            break;
        }
    }
    return type;
}


+ (NSString *)transformToPinyin:(NSString*)chinese{
    NSMutableString *mutableString = [NSMutableString stringWithString:chinese];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}

+ (BOOL)isValidateEmail:(NSString *)Email
{
    NSString *emailCheck = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    return [emailTest evaluateWithObject:Email];
}

+ (BOOL) isValidatePostCode:(NSString *) postCode{
    NSString *postCodeCheck = @"^[1-9][0-9]{5}$";
    NSPredicate *postCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",postCodeCheck];
    return [postCodeTest evaluateWithObject:postCode];
}

 //判断手机号码格式是否正确
+ (BOOL)isValidateMobile:(NSString *)mobileNum{
    mobileNum = [mobileNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobileNum.length != 11)
    {
        return NO;
    }else{
        //手机号以13，14，15，18开头，八个 \d 数字字符
        NSString *phoneRegex = @"^1(3[0-9]|4[0-9]|5[012356789]|6[2567]|7[0-8]|8[0-9]|9[01256789])\\d{8}$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        return [phoneTest evaluateWithObject:mobileNum];
    }
    return NO;
}

//身份证号
+ (BOOL)isValidateIdentityCard: (NSString *)identityCard{
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(identityCard.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                idCardWiSum+= subStrIndex * idCardWiIndex;
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
}

+ (BOOL)isValidateNumber:(NSString *)number {
    NSString *check = @"^[0-9]*$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",check];
    return [pre evaluateWithObject:number];
}

//判断字符串是否是整型
+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}
+ (BOOL)isValidatePwd:(NSString *)pwd{
    NSString *pwdCheck = @"^[0-9a-zA-Z]{6,16}$";
    NSPredicate *pwdTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pwdCheck];
    return [pwdTest evaluateWithObject:pwd];
}


+ (UIViewController*)superViewController:(UIView *)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


//大写转小写
+ (NSString *)TurnUppercaseLowercase:(NSString *)str{
    return [str lowercaseString];
}

+ (BOOL)isIncludeSpecialCharact: (NSString *)str {
    
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
        
    {
        return NO;
    }
    return YES;
    
}


//字符串去掉空格
+ (NSString *)stringWithOutSpace:(NSString *)str{
    NSString * newStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newStr;
}


//隐藏手机号中间四位
+ (NSString *)hiddenTelPhoneMiddel:(NSString *)telNO{
    NSString *MOBILE = @"^[1][3578]\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if (([regextestmobile evaluateWithObject:telNO] == YES))
        
    {
        return  [telNO stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] ;
    }
    else
    {
        return telNO;
    }
    
}

//判断是不是整数
+ (BOOL)isValidateInt:(NSString *)str{
    NSScanner* scan = [NSScanner scannerWithString:str];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
}


//正浮点数
+ (BOOL) isFloatData:(NSString *)data{
    
    //不能以0\d开头的数据
    NSString *str = @"^0\\d+$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    if (![pre evaluateWithObject:data]) {
        NSString *floatCheck = @"^\\d+\\.?\\d{0,2}$";
        NSPredicate *floatTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",floatCheck];
        
        return [floatTest evaluateWithObject:data];
    }else{
        return NO;
    }
}

//判断两个字符串是否相等<不区分大小写>
+ (BOOL) towStringIsEqual:(NSString *)str1 Str2:(NSString *)str2
{
    if ([str1 caseInsensitiveCompare:str2] == NSOrderedSame) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)fwbLabel:(UILabel *)LB FontNumber:(id)font FirstStr:(NSString *)firstStr LastStr:(NSString *)lastStr AndColor:(UIColor *)color{
    
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:LB.text];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc = [[noteStr string] rangeOfString:firstStr].location + 1;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc = 0;
    if (lastStr.length > 0) {
        secondLoc = [[noteStr string] rangeOfString:lastStr].location;
    }else{
        secondLoc = LB.text.length;
    }
    // 需要改变的区间
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    // 改变字体大小及类型
    if (font) {
        [noteStr addAttribute:NSFontAttributeName value:font range:range];
    }
    // 为label添加Attributed
    [LB setAttributedText:noteStr];
    
}

/** 按照中文两个字符，英文数字一个字符计算字符数*/
+ (NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

/** 判断是否为中文 */
+ (BOOL)isChinese:(NSString *)str
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}
/**
 *  判断当前时间是否处于某个时间段内
 *
 *  @param startTime        开始时间
 *  @param expireTime       结束时间
 */
+ (BOOL)validateWithStartTime:(NSString *)startTime withExpireTime:(NSString *)expireTime{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:kDateFormat_yyyyMdHm];
    
    NSString *nowDateStr = [dateFormat stringFromDate:today];
    NSDate *now = [dateFormat dateFromString:nowDateStr];
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    //在时间段区间
    if ([now compare:start] == NSOrderedDescending && [now compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}
/** 判断时间还未开始 */
+ (BOOL)unBeginWithStartTime:(NSString *)startTime{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:kDateFormat_yyyyMdHm];
    
    NSString *nowDateStr = [dateFormat stringFromDate:today];
    NSDate *now = [dateFormat dateFromString:nowDateStr];
    NSDate *start = [dateFormat dateFromString:startTime];
    if ([now compare:start] == NSOrderedDescending) {
        return YES;
    }else{
        
      return NO;
    }
}
/** 判断是否已经结束 */
+ (BOOL)endWithExpireTime:(NSString *)expireTime{
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:kDateFormat_yyyyMdHm];
    
    NSString *nowDateStr = [dateFormat stringFromDate:today];
    NSDate *now = [dateFormat dateFromString:nowDateStr];
    NSDate *expire = [dateFormat dateFromString:expireTime];

    if ([now compare:expire] == NSOrderedAscending) {
        return YES;
    }else{
       return NO;
    }
    
}
/** 判断是否和当前时间一致 */
+ (BOOL)sameWithExpireTime:(NSString *)expireTime{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:kDateFormat_yMd];
    
    NSString *nowDateStr = [dateFormat stringFromDate:today];
    NSDate *now = [dateFormat dateFromString:nowDateStr];
    NSDate *expire = [dateFormat dateFromString:expireTime];

    if ([now compare:expire] == NSOrderedSame) {
        return YES;
    }else{
       return NO;
    }
    
}
/** 比较两个时间 */
+ (NSInteger)compareTimeWithStartTime:(NSString *)startTime ExpireTime:(NSString *)expireTime{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:kDateFormat_yMd];
    
    /*
     NSOrderedAscending = -1L,表示两个比较的对象前者小于后置
     NSOrderedSame, 表示比较的对象相等
     NSOrderedDescending表示两个比较的对象前者大于后者
     */
    
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    if ([start compare:expire] == NSOrderedAscending) {//后者大
        return -1;
    }else if([start compare:expire] ==NSOrderedSame){//时间相等
        return 0;
    }else{//前者大
        return 1;
    }
    
}

/**将时间戳(秒)按时间格式转成时间字符串*/
+ (NSString*)timintervalToTimeStr:(NSString*)dateFormatStr timeInterval:(NSInteger)secondValue{
    if (!secondValue) {
        secondValue = 0;
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:secondValue];
      NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    if (kStringIsEmpty(dateFormatStr)) {
        dateFormatStr = @"yyyy-MM-dd HH:mm";
    }
      [dateFormat setDateFormat:dateFormatStr];
     
    return [dateFormat stringFromDate:confromTimesp];
}
/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}



/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self containChinese:self]) {  //如果包含中文
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}



/**
 *  计算最大行数文字高度,可以处理计算带行间距的
 */
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines{
    
    if (maxLines <= 0) {
        return 0;
    }
    
    CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing * (maxLines - 1);
    
    CGSize orginalSize = [self boundingRectWithSize:size font:font lineSpacing:lineSpacing];
    
    if ( orginalSize.height >= maxHeight ) {
        return maxHeight;
    }else{
        return orginalSize.height;
    }
}

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing{
    
    if ( [self boundingRectWithSize:size font:font lineSpacing:lineSpacing].height > font.lineHeight  ) {
        return YES;
    }else{
        return NO;
    }
}
//判断是否包含中文
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}
/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)jk_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)jk_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.width);
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)jk_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)jk_sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}


/**
 *  @brief  反转字符串
 *
 *  @param strSrc 被反转字符串
 *
 *  @return 反转后字符串
 */
+ (NSString *)jk_reverseString:(NSString *)strSrc
{
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [strSrc length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[strSrc substringWithRange:subStrRange]];
    }
    return reverseString;
}

+ (NSString*)arrayToJSONString:(NSArray *)array

{
    
    NSError *error = nil;
    //    NSMutableArray *muArray = [NSMutableArray array];
    //    for (NSString *userId in array) {
    //        [muArray addObject:[NSString stringWithFormat:@"\"%@\"", userId]];
    //    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSLog(@"json array is: %@", jsonResult);
    return jsonString;
}

+ (NSArray *)jsonStrToArray:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

+(NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSLog(@"1296035591  = %@",confromTimesp);
    
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    
    
    return confromTimespStr;
    
}

//字典转json格式字符串：

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */



+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
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

+ (NSMutableAttributedString*)attributeWithStr:(NSString*)str  lineSpace:(CGFloat)lineSpace
{
    if(!str) return nil;
    
    //实例化NSMutableAttributedString模型
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    //建立行间距模型
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //设置行间距
    [paragraphStyle setLineSpacing:lineSpace];
    //把行间距模型加入NSMutableAttributedString模型
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    return attributedString;
    
}
#pragma mark -多种颜色的字符
+(NSMutableAttributedString *)getAttributeStr:(NSString *)text topLength:(CGFloat)topLength topColor:(UIColor *)topColor afterLength:(CGFloat)afterLength afterColor:(UIColor *)afterColor topFont:(UIFont *)topFont afterFont:(UIFont *)afterFont{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:topColor range:NSMakeRange(0,topLength)];
    [str addAttribute:NSForegroundColorAttributeName value:afterColor range:NSMakeRange(topLength,str.length - topLength)];
    [str addAttribute:NSFontAttributeName value:topFont range:NSMakeRange(0, topLength)];
    [str addAttribute:NSFontAttributeName value:afterFont range:NSMakeRange(topLength, str.length - topLength)];
    return str;
}
+ (NSString*)dateStringBytimeStampString;
{
    // timeStampString 是服务器返回的13位时间戳
    NSString *timeStampString  =self;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =[timeStampString doubleValue] / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString  = [formatter stringFromDate: date];
    return dateString;
}

#pragma mark - 将某个时间戳转化成 时间
+ (NSString *)stringOutSpaceAndEnter:(NSString*)str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


//浮点数处理并去掉多余的0
+(NSString *)stringDisposeWithStr:(NSString*)str
{
    long len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        //s.substring(0, len - i - 1);
        return [str substringToIndex:[str length]-1];
    }
    else
    {
        return str;
    }
}

@end
