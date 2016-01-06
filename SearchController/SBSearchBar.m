//
//  SBSearchBar.m
//  SBSearchDemo
//
//  Created by xiaoshaobin on 15/12/14.
//  Copyright (c) 2015年 xiaoshaobin. All rights reserved.
//

#import "SBSearchBar.h"
#import "SBSearchTool.h"

@interface SBSearchBar ()

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIButton *cancleButton;

@property (nonatomic,strong) UIButton *unActiveIcon;

@property (nonatomic,assign) BOOL isAnimating;

@end

@implementation SBSearchBar

- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.placeholder = @"搜索";
        _textField.layer.borderWidth = 0.5;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.layer.cornerRadius = 4;
        _textField.backgroundColor = [SBSearchTool colorWithUInt:0xf2f3f5];
    }
    return _textField;
}

- (UIButton *)cancleButton
{
    if (!_cancleButton)
    {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[SBSearchTool colorWithUInt:0x398de3] forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancleButton addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancleButton sizeToFit];
        
        CGRect cancleRect = _cancleButton.frame;
        cancleRect.origin.x = CGRectGetWidth(self.frame);
        cancleRect.origin.y = 6;
        _cancleButton.frame = cancleRect;
        
    }
    return _cancleButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        if (CGRectEqualToRect(self.frame, CGRectZero))
        {
            self.frame = CGRectMake(0, 0, CGRectGetWidth(newSuperview.frame), 44);
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self.textField];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self.textField];
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:self.textField];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:self.textField];
    }
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview)
    {
        
        [self addSubview:self.textField];
        [self addSubview:self.cancleButton];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.isAnimating)
    {
        if (self.isFirstResponder)
        {
            CGRect cancleRect = self.cancleButton.frame;
            cancleRect.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(cancleRect) - 10;
            cancleRect.origin.y = 6;
            self.cancleButton.frame = cancleRect;
            
            CGRect textFieldRect = CGRectZero;
            textFieldRect.origin = CGPointMake(10, 6);
            textFieldRect.size.width = CGRectGetMinX(cancleRect) - CGRectGetMinX(textFieldRect) - 10;
            textFieldRect.size.height = CGRectGetHeight(self.frame) - 2 * CGRectGetMinY(textFieldRect);
            self.textField.frame = textFieldRect;
        }
        else
        {
            CGRect cancleRect = self.cancleButton.frame;
            cancleRect.origin.x = CGRectGetWidth(self.frame);
            cancleRect.origin.y = 6;
            self.cancleButton.frame = cancleRect;
            
            CGRect textFieldRect = CGRectZero;
            textFieldRect.origin = CGPointMake(10, 6);
            textFieldRect.size.width = CGRectGetWidth(self.frame) - 2 * CGRectGetMinX(textFieldRect);
            textFieldRect.size.height = CGRectGetHeight(self.frame) - 2 * CGRectGetMinY(textFieldRect);
            self.textField.frame = textFieldRect;
        }
    }
}

#pragma Setter


#pragma mark - 其他

- (void)cancleButtonClick:(UIButton *)button
{
    [self resignFirstResponder];
}

- (BOOL)isFirstResponder
{
    return self.textField.isFirstResponder;
}

- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(NSNotification *)notification
{
    if (notification.object == self.textField)
    {
        CGRect cancleRect = self.cancleButton.frame;
        cancleRect.origin.x = CGRectGetWidth(self.frame);
        self.cancleButton.frame = cancleRect;
        cancleRect.origin.x = CGRectGetWidth(self.frame) - CGRectGetWidth(cancleRect) - 10;
        
        CGRect textFieldRect = self.textField.frame;
        textFieldRect.size.width = CGRectGetMinX(cancleRect) - CGRectGetMinX(textFieldRect) - 10;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.isAnimating = YES;
            self.cancleButton.frame = cancleRect;
            self.textField.frame = textFieldRect;
            
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }
}

- (void)textFieldDidEndEditing:(NSNotification *)notification
{
    if (notification.object == self.textField)
    {
        CGRect cancleRect = self.cancleButton.frame;
        cancleRect.origin.x = CGRectGetWidth(self.frame);
        
        CGRect textFieldRect = self.textField.frame;
        textFieldRect.size.width = CGRectGetWidth(self.frame) - 2 * CGRectGetMinX(textFieldRect);
        
        [UIView animateWithDuration:0.25 animations:^{
            self.isAnimating = YES;
            self.cancleButton.frame = cancleRect;
            self.textField.frame = textFieldRect;
            
        } completion:^(BOOL finished) {
            self.isAnimating = NO;
        }];
    }
}









@end
