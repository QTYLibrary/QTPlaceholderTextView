//
//  ViewController.m
//  QTPlaceholderTextView
//
//  Created by QinTuanye on 2019/7/19.
//  Copyright © 2019 QinTuanye. All rights reserved.
//

#import "ViewController.h"
#import "QTPlaceholderTextView.h"

#define MAX_TEXT_COUNT 100

@interface ViewController () <UITextViewDelegate>

@property (nonatomic, strong) QTPlaceholderTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:248/255.0 blue:250/255.0 alpha:1.0];
    
    _textView = [[QTPlaceholderTextView alloc] init];
    
    self.textView.text = @"收快递费熟练度附近是凉快圣诞节福利索拉卡废旧塑料是两款发动机是单例父控件啥两地分居斯洛伐克阿熟练度附近暗示了大富科技萨拉塑料袋积分拉伸的老师端开了房是单例父控件思考的房间";
    [self.textView showTextCount:YES];
    CGSize size = [self.textView sizeThatFits:CGSizeMake(self.view.frame.size.width - 36, CGFLOAT_MAX)];
    self.textView.frame = CGRectMake(16, 150, self.view.frame.size.width - 36, size.height);
    self.textView.placeholder = @"要说些什么吗";
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.textCount = [NSString stringWithFormat:@"%zd/%d", (self.textView.text ? self.textView.text.length : 0), MAX_TEXT_COUNT];
    self.textView.delegate = self;
    
    [self.view addSubview:self.textView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - 其他方法
- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"range: %@ %@", NSStringFromRange(range), text);
    //不支持系统表情的输入
    if ([[textView textInputMode] primaryLanguage] == nil ||
        [[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    if ([self isBlankString:text]) {
        return YES;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange =NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < MAX_TEXT_COUNT) {
            return YES;
        } else {
            return NO;
        }
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_TEXT_COUNT - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    } else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        if (rg.length >0) {
            NSString *s =@"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            } else {
                __block NSInteger idx =0;
                __block NSString *trimString =@"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring,NSRange substringRange,NSRange enclosingRange,BOOL* stop) {
                                          if (idx >= rg.length) {
                                              *stop =YES;//取出所需要就break，提高效率
                                              return ;
                                          }
                                          trimString = [trimString stringByAppendingString:substring];
                                          idx++;
                                      }];
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text  stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
        }
        return NO;
        
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.textView showPlaceholder:(self.textView.text.length == 0)];
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    NSString *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    if (existTextNum > MAX_TEXT_COUNT){
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_TEXT_COUNT];
        [textView setText:s];
    }
    self.textView.textCount = [NSString stringWithFormat:@"%ld/%d", self.textView.text.length, MAX_TEXT_COUNT];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.textView showPlaceholder:(self.textView.text.length == 0)];
}

@end
