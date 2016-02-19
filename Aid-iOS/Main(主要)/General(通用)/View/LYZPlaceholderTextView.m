//
//  LYZPlaceholderTextView.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/16.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "LYZPlaceholderTextView.h"

@interface LYZPlaceholderTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end


@implementation LYZPlaceholderTextView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _placeholder = @"";
        _placeholderColor = [UIColor lightGrayColor];
        _placeholderFont = self.font;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public methods

#pragma mark - override super

- (void)drawRect:(CGRect)rect
{
    if(self.placeholder.length > 0){
        if (! _placeHolderLabel){
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 8, self.bounds.size.width - 16, 0)];
            _placeHolderLabel.tag = 999;
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.alpha = 0;
            
            [self addSubview:_placeHolderLabel];
        }
        _placeHolderLabel.text = self.placeholder;
        _placeHolderLabel.font = self.placeholderFont;
        [_placeHolderLabel sizeToFit];
        
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if(self.text.length == 0 && self.placeholder.length > 0 ){
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self textChanged:nil];
}

#pragma mark - event response

#pragma mark - notification response

- (void)textChanged:(NSNotification *)notification
{
    if (self.placeholder.length == 0) {
        return;
    }
    
    if (self.text.length == 0) {
        [[self viewWithTag:999] setAlpha:1];
    }
    else {
        [[self viewWithTag:999] setAlpha:0];
    }
}

#pragma mark - private methods

#pragma mark - getters and setters

@end
