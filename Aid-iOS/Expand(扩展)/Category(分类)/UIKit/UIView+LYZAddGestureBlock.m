//
//  UIView+LYZAddGestureBlock.m
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "UIView+LYZAddGestureBlock.h"

static char kWhenTappedBlockKey;
static char kWhenDoubleTappedBlockKey;
static char kWhenTwoFingerTappedBlockKey;
static char kWhenTouchedDownBlockKey;
static char kWhenTouchedUpBlockKey;

@implementation UIView (LYZAddGestureBlock)

#pragma mark - public method

- (void)tapped:(AddGestureBlock)block
{
    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewWasTapped)];
    [self addRequiredToDoubleTapsRecognizer:gesture];
    
    [self setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)doubleTapped:(AddGestureBlock)block
{
    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:2 touches:1 selector:@selector(viewWasDoubleTapped)];
    [self addRequirementToSingleTapsRecognizer:gesture];
    
    [self setBlock:block forKey:&kWhenDoubleTappedBlockKey];
}

- (void)twoFingerTapped:(AddGestureBlock)block
{
    [self addTapGestureRecognizerWithTaps:1 touches:2 selector:@selector(viewWasTwoFingerTapped)];
    
    [self setBlock:block forKey:&kWhenTwoFingerTappedBlockKey];
}

- (void)touchedDown:(AddGestureBlock)block
{
    [self setBlock:block forKey:&kWhenTouchedDownBlockKey];
}

- (void)touchedUp:(AddGestureBlock)block
{
    [self setBlock:block forKey:&kWhenTouchedUpBlockKey];
}

#pragma mark - override super

#pragma mark - private methods

- (UITapGestureRecognizer*)addTapGestureRecognizerWithTaps:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector
{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = taps;
    tapGesture.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGesture];
    
    return tapGesture;
}

- (void)addRequirementToSingleTapsRecognizer:(UIGestureRecognizer*) recognizer
{
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 1 && tapGesture.numberOfTapsRequired == 1) {
                [tapGesture requireGestureRecognizerToFail:recognizer];
            }
        }
    }
}

- (void)addRequiredToDoubleTapsRecognizer:(UIGestureRecognizer*) recognizer
{
    for (UIGestureRecognizer* gesture in [self gestureRecognizers]) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            UITapGestureRecognizer* tapGesture = (UITapGestureRecognizer*) gesture;
            if (tapGesture.numberOfTouchesRequired == 2 && tapGesture.numberOfTapsRequired == 1) {
                [recognizer requireGestureRecognizerToFail:tapGesture];
            }
        }
    }
}

#pragma mark - notification response

#pragma mark - event response

- (void)viewWasTapped
{
    [self blockForKey:&kWhenTappedBlockKey];
}

- (void)viewWasDoubleTapped
{
    [self blockForKey:&kWhenDoubleTappedBlockKey];
}

- (void)viewWasTwoFingerTapped
{
    [self blockForKey:&kWhenTwoFingerTappedBlockKey];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self blockForKey:&kWhenTouchedDownBlockKey];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self blockForKey:&kWhenTouchedUpBlockKey];
}

#pragma mark- getters and setters

- (void)blockForKey:(void *)key
{
    AddGestureBlock block = [self getAssociatedValueForKey:key];
    if (block) {
        block();
    }
}

- (void)setBlock:(AddGestureBlock)block forKey:(void *)key
{
    self.userInteractionEnabled = YES;
    [self setAssociateValue:block withKey:key];
}

@end
