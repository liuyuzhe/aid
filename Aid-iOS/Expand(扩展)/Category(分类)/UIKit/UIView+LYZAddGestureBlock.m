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

static char kWhenRotationBlockKey;
static char kWhenPinchBlockKey;
static char kWhenPanBlockKey;

@implementation UIView (LYZAddGestureBlock)

#pragma mark - public methods

- (void)tappedGesture:(AidGestureRecognizerSuccess)block
{
    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:1 touches:1 selector:@selector(viewWasTapped)];
    [self addRequiredToDoubleTapsRecognizer:gesture];
    
    [self setBlock:block forKey:&kWhenTappedBlockKey];
}

- (void)doubleTappedGesture:(AidGestureRecognizerSuccess)block
{
    UITapGestureRecognizer* gesture = [self addTapGestureRecognizerWithTaps:2 touches:1 selector:@selector(viewWasDoubleTapped)];
    [self addRequirementToSingleTapsRecognizer:gesture];
    
    [self setBlock:block forKey:&kWhenDoubleTappedBlockKey];
}

- (void)twoFingerTappedGesture:(AidGestureRecognizerSuccess)block
{
    [self addTapGestureRecognizerWithTaps:1 touches:2 selector:@selector(viewWasTwoFingerTapped)];
    
    [self setBlock:block forKey:&kWhenTwoFingerTappedBlockKey];
}

- (void)touchedDownGesture:(AidGestureRecognizerSuccess)block
{
    [self setBlock:block forKey:&kWhenTouchedDownBlockKey];
}

- (void)touchedUpGesture:(AidGestureRecognizerSuccess)block
{
    [self setBlock:block forKey:&kWhenTouchedUpBlockKey];
}

#pragma mark -

- (void)rotationGesture:(AidGestureRecognizerSuccess)block
{
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [self addGestureRecognizer:rotationGesture];
    
    [self setBlock:block forKey:&kWhenRotationBlockKey];
}

- (void)pinchGesture:(AidGestureRecognizerSuccess)block
{
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self addGestureRecognizer:pinchGesture];
    
    [self setBlock:block forKey:&kWhenPinchBlockKey];
}

- (void)panGesture:(AidGestureRecognizerSuccess)block
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self addGestureRecognizer:panGesture];
    
    [self setBlock:block forKey:&kWhenPanBlockKey];
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

#pragma mark -

/** 旋转视图 */
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGesture
{
    [self blockForKey:&kWhenRotationBlockKey];
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan || rotationGesture.state == UIGestureRecognizerStateChanged) {
        self.transform = CGAffineTransformRotate(self.transform, rotationGesture.rotation);
        [rotationGesture setRotation:0];
    }
}

/** 缩放视图 */
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGesture
{
    [self blockForKey:&kWhenPinchBlockKey];

    if (pinchGesture.state == UIGestureRecognizerStateBegan || pinchGesture.state == UIGestureRecognizerStateChanged) {
        self.transform = CGAffineTransformScale(self.transform, pinchGesture.scale, pinchGesture.scale);
        pinchGesture.scale = 1;
    }
}

/** 拖拽视图 */
- (void)panView:(UIPanGestureRecognizer *)panGesture
{
    [self blockForKey:&kWhenPanBlockKey];

    if (panGesture.state == UIGestureRecognizerStateBegan || panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGesture translationInView:self.superview];
        [self setCenter:(CGPoint){self.center.x + translation.x, self.center.y + translation.y}];
        [panGesture setTranslation:CGPointZero inView:self.superview];
    }
}

#pragma mark- getters and setters

- (void)blockForKey:(void *)key
{
    AidGestureRecognizerSuccess block = [self getAssociatedValueForKey:key];
    if (block) {
        block();
    }
}

- (void)setBlock:(AidGestureRecognizerSuccess)block forKey:(void *)key
{
    self.userInteractionEnabled = YES;
    [self setAssociateValue:block withKey:key];
}

@end
