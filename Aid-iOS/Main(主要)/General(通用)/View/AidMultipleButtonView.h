//
//  AidMultipleButtonView.h
//  
//
//  Created by 刘育哲 on 15/11/17.
//
//

#import <UIKit/UIKit.h>

typedef void(^multipleButtonAction)(NSInteger index);

@interface AidMultipleButtonView : UIView

@property (nonatomic, copy) multipleButtonAction buttonTouched;


- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray <NSString *> *)titleArray;

@end
