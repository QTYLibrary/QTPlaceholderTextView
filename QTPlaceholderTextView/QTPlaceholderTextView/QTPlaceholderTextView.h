//
//  QTPlaceholderTextView.h
//  QTPlaceholderTextView
//
//  Created by QinTuanye on 2019/7/19.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QTPlaceholderTextView : UIView

/**
 占位字符串
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 内容
 */
@property (nonatomic, copy) NSString *text;

/**
 字体
 */
@property (nonatomic, strong) UIFont *font;

/**
 文本颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 占位符文本颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;

/**
 字数文本字体
 */
@property (nonatomic, strong) UIFont *countFont;

/**
 字数文本颜色
 */
@property (nonatomic, strong) UIColor *countColor;

/**
 字数
 */
@property (nonatomic, copy) NSString *textCount;

/**
 内容边距
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 字数边距
 */
@property (nonatomic, assign) UIEdgeInsets countInsets;

/**
 代理
 */
@property (nonatomic, weak) id<UITextViewDelegate> delegate;

/**
 是否显示占位符

 @param show YES -> 显示， NO -> 隐藏
 */
- (void)showPlaceholder:(BOOL)show;

/**
 是否显示字数

 @param show YES -> 显示， NO -> 隐藏
 */
- (void)showTextCount:(BOOL)show;

/**
 计算文本视图的高度

 @param size CGSize
 @return CGSize
 */
- (CGSize)sizeThatFits:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
