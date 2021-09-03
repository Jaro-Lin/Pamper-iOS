//
//  UILabel+MCLabel.m
//  MCLabel

#import "UILabel+MCLabel.h"
#import <CoreText/CoreText.h>

@implementation UILabel (MCLabel)

- (void)setColumnSpace:(CGFloat)columnSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整间距
    [attributedString addAttribute:(__bridge NSString *)kCTKernAttributeName value:@(columnSpace) range:NSMakeRange(0, [attributedString length])];
    self.attributedText = attributedString;
}

- (void)setRowSpace:(CGFloat)rowSpace
{
    self.numberOfLines = 0;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = rowSpace;
//    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

- (void)setTextDirection:(MCTextDirection)direction
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    //调整行距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (direction == MCTextDirectionNatural) {
        paragraphStyle.baseWritingDirection = NSWritingDirectionNatural;
    }else if (direction == MCTextDirectionRight){
        paragraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;
    }else{
        paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.text length])];
    self.attributedText = attributedString;
}

+(CGFloat)getDynamicSizeText:(NSString *)text WithFrame:(CGSize)cgSize WithFont:(CGFloat)fontSize{
    
       NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = 2;
    //Attribute传和label设定的一样
        NSDictionary * attributes = @{
                                      NSFontAttributeName:[UIFont systemFontOfSize:12.f],
                                      NSParagraphStyleAttributeName: paragraphStyle
                                      };
    
    //这里的size，width传label的宽，高默认都传MAXFLOAT
        CGFloat textHeight = [text boundingRectWithSize: cgSize
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:attributes
                                               context:nil].size.height;
    
    
    CGSize titleSize =[text boundingRectWithSize:cgSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return titleSize.height;
}
@end
