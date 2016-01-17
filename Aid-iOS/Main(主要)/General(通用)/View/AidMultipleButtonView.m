//
//  AidMultipleButtonView.m
//  
//
//  Created by 刘育哲 on 15/11/17.
//
//

#import "AidMultipleButtonView.h"

@interface AidMultipleButtonView ()

@property (nonatomic, strong) UIButton *selectedButton;

@end



@implementation AidMultipleButtonView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    if (self = [super initWithFrame:frame]) {
        NSInteger buttonCount = titleArray.count;
        for (int i = 0; i < titleArray.count ; i ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i +10;
            button.frame = CGRectMake(i * self.width/buttonCount, 5 , self.width/buttonCount, 30);
            button.layer.borderColor= [UIColor whiteColor].CGColor;
            button.layer.borderWidth = 0.5;
            
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            
            if (i == 0) {
                button.selected = YES;
                _selectedButton = button;
            }
            
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }
    return self;
}

#pragma mark - event response

- (void)buttonAction:(UIButton *)button
{
    if (! _selectedButton) {
        _selectedButton = button;
        _selectedButton.selected = ! _selectedButton.selected;
    }
    else {
        _selectedButton.selected = NO;
        _selectedButton = button;
        _selectedButton.selected = YES;
    }
    
    if (self.buttonTouched) {
        self.buttonTouched(button.tag - 10);
    }
}

@end
