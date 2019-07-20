//
//  QTPlaceholderTextView.m
//  QTPlaceholderTextView
//
//  Created by QinTuanye on 2019/7/19.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "QTPlaceholderTextView.h"

#define DEFAULT_COUNT_LABEL_HIDDE       YES     // 默认是否显示字数统计
#define DEFAULT_FONT                    [UIFont fontWithName:@"PingFang SC" size: 16]   // UITextView默认字体
#define DEFAUTL_TEXT_COLOR              [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1.0]  // UITextView的默认字体颜色
#define DEFAULT_PLACEHOLDER_COLOR       [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0]   // 占位字符颜色
#define DEFAULT_COUNT_FONT              [UIFont fontWithName:@"PingFang SC" size: 16]   // 字数统计默认字体
#define DEFAULT_COUNT_COLOR             [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]   // 字数统计默认字体颜色
#define DEFAULT_CONTENT_INSETS_TOP      8   // 内容距离顶部内边距
#define DEFAULT_CONTENT_INSETS_LEFT     8   // 内容距离左边内边距
#define DEFAULT_CONTENT_INSETS_BOTTOM   8   // 内容距离底部内边距
#define DEFAULT_CONTENT_INSETS_RIGHT    8   // 内容距离右边内边距
#define DEFAULT_COUNT_INSETS_TOP        8   // 字数统计距离顶部外边距
#define DEFAULT_COUNT_INSETS_LEFT       16  // 字数统计距离左边外边距
#define DEFAULT_COUNT_INSETS_BOTTOM     0   // 字数统计距离底部外边距
#define DEFAULT_COUNT_INSETS_RIGHT      16  // 字数统计距离右边外边距


@interface QTPlaceholderTextView()

/**
 占位符视图
 */
@property (nonatomic, strong) UITextView *placeholderView;
/**
 内容视图
 */
@property (nonatomic, strong) UITextView *contentView;
/**
 字数标签
 */
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation QTPlaceholderTextView

/**
 同时重新getter和setter方法，系统不会自动生成_text变量名，需要使用下面代码创建_text变量名
 */
@synthesize text = _text;

#pragma mark - 父类方法
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupValues];
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupValues];
        [self setupViews];
        [self updateViewsFrame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self updateViewsFrame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateViewsFrame];
}

#pragma mark - 类方法
- (void)showPlaceholder:(BOOL)show {
    self.placeholderView.hidden = !show;
}

- (void)showTextCount:(BOOL)show {
    self.countLabel.hidden = !show;
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = CGSizeMake(size.width - (self.contentInsets.left + self.contentInsets.right), size.height);
    CGSize fitSize = [self.contentView sizeThatFits:size];
    CGFloat height = fitSize.height + self.contentInsets.top + self.contentInsets.bottom;
    if (!self.countLabel.hidden) {
        CGSize size = [self.countLabel.text sizeWithAttributes:@{NSFontAttributeName:self.countFont}];
        height += size.height + self.countInsets.top + self.countInsets.bottom;
    }
    return CGSizeMake(fitSize.width, height);
}

#pragma mark - 初始化变量
- (void)setupValues {
    _placeholder = @"";
    _textCount = @"";
    _font = DEFAULT_FONT;
    _textColor = DEFAUTL_TEXT_COLOR;
    _placeholderColor = DEFAULT_PLACEHOLDER_COLOR;
    _countFont = DEFAULT_COUNT_FONT;
    _countColor = DEFAULT_COUNT_COLOR;
    _contentInsets = UIEdgeInsetsMake(DEFAULT_CONTENT_INSETS_TOP, DEFAULT_CONTENT_INSETS_LEFT, DEFAULT_CONTENT_INSETS_BOTTOM, DEFAULT_CONTENT_INSETS_RIGHT);
    _countInsets = UIEdgeInsetsMake(DEFAULT_COUNT_INSETS_TOP, DEFAULT_COUNT_INSETS_LEFT, DEFAULT_COUNT_INSETS_BOTTOM, DEFAULT_COUNT_INSETS_RIGHT);
}

#pragma mark - 初始化视图
- (void)setupViews {
    _placeholderView = [[UITextView alloc] init];
    _contentView = [[UITextView alloc] init];
    _countLabel = [[UILabel alloc] init];
    
    self.placeholderView.text = self.placeholder;
    self.placeholderView.font = self.font;
    self.placeholderView.textColor = self.placeholderColor;
    self.placeholderView.backgroundColor = [UIColor clearColor];
    self.placeholderView.editable = NO;
    
    self.contentView.font = self.font;
    self.contentView.textColor = self.textColor;
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.countLabel.text = self.textCount;
    self.countLabel.font = self.countFont;
    self.countLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel.textColor = self.countColor;
    self.countLabel.hidden = DEFAULT_COUNT_LABEL_HIDDE;
    
    [self addSubview:self.placeholderView];
    [self addSubview:self.contentView];
    [self addSubview:self.countLabel];
}

- (void)updateViewsFrame {
    if (!self.countLabel) {
        return;
    }
    if (self.countLabel.hidden) {
        self.placeholderView.frame = CGRectMake(self.contentInsets.left, self.contentInsets.top, self.frame.size.width - (self.contentInsets.left + self.contentInsets.right), self.frame.size.height - (self.contentInsets.top + self.contentInsets.bottom));
        self.contentView.frame = CGRectMake(self.contentInsets.left, self.contentInsets.top, self.frame.size.width - (self.contentInsets.left + self.contentInsets.right), self.frame.size.height - (self.contentInsets.top + self.contentInsets.bottom));
        self.countLabel.frame = CGRectZero;
    } else {
        CGSize size = [self.countLabel.text sizeWithAttributes:@{NSFontAttributeName:self.countFont}];
        CGFloat contentHeight = self.frame.size.height - (self.contentInsets.top + self.contentInsets.bottom + size.height + self.countInsets.top + self.countInsets.bottom);
        self.placeholderView.frame = CGRectMake(self.contentInsets.left, self.contentInsets.top, self.frame.size.width - (self.contentInsets.left + self.contentInsets.right), contentHeight);
        self.contentView.frame = CGRectMake(self.contentInsets.left, self.contentInsets.top, self.frame.size.width - (self.contentInsets.left + self.contentInsets.right), contentHeight);
        self.countLabel.frame = CGRectMake(self.countInsets.left, CGRectGetMaxY(self.contentView.frame) + self.countInsets.top, self.frame.size.width - (self.countInsets.left + self.countInsets.right), size.height);
    }
}

#pragma mark - getter方法
- (NSString *)text {
    _text = self.contentView.text;
    return _text;
}

#pragma mark - setter方法
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderView.text = _placeholder;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.contentView.text = _text;
    self.placeholderView.hidden = (_text && (_text.length > 0));
}

- (void)setTextCount:(NSString *)textCount {
    _textCount = textCount;
    self.countLabel.text = _textCount;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self updateViewsFrame];
}

- (void)setCountInsets:(UIEdgeInsets)countInsets {
    _countInsets = countInsets;
    [self updateViewsFrame];
}

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    _delegate = delegate;
    self.contentView.delegate = _delegate;
}

@end
