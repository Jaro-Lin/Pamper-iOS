//
//  SYChatKeyBoardView.h
//  SYBaseProject
//
//  Created by apple on 2020/8/4.
//  Copyright © 2020 YYB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SYChatKeyBoardViewDelegate <NSObject>
@optional
- (void)editeButtonClick;
- (void)likeButtonClick;
- (void)collectionButtonClick;
- (void)inputTextViewEndEdite:(NSString*)commontStr;

@end


@interface SYChatKeyBoardView : UIView<UITextViewDelegate>
 @property (nonatomic,weak) id<SYChatKeyBoardViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextViewHeightMargin;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *editeBtn;

@end

NS_ASSUME_NONNULL_END
