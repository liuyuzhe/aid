//
//  AidMultipleButtonView.m
//  
//
//  Created by 刘育哲 on 15/11/17.
//
//

#import "AidMultipleButtonView.h"

#define AidButtonStateNormal [UIColor whiteColor]
#define AidButtonStateSelected [UIColor blackColor]
static const CGFloat AidButtonTopOffset = 5.;

@interface AidMultipleButtonView ()

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) NSArray <NSString *> *titleArray; /**< title数组 */

@end


@implementation AidMultipleButtonView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray <NSString *> *)titleArray
{
    if (self = [super initWithFrame:frame]) {
        _titleArray = titleArray;

        [self setupPageSubviews];

        [self layoutPageSubviews];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark - life cycle helper

- (void)setupPageSubviews
{
    CGFloat width = self.width / _titleArray.count;
    CGFloat height = self.height - 2 * AidButtonTopOffset;

    for (int i = 0; i < _titleArray.count ; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i * width, AidButtonTopOffset , width, height)];
        button.tag = i +10;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.layer.borderColor= AidButtonStateNormal.CGColor;
        button.layer.borderWidth = 0.5;
        
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:AidButtonStateNormal forState:UIControlStateNormal];
        [button setTitleColor:AidButtonStateSelected forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            button.selected = YES;
            _selectedButton = button;
        }
        
        [self addSubview:button];
    }
}

- (void)layoutPageSubviews
{
    __weak UIView *weakSelf = self;
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
