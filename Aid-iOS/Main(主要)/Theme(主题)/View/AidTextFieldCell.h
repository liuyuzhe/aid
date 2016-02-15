//
//  AidTextFieldCell.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/6.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AidTextFieldCellStyle) {
    AidTextFieldCellStyleName = 1,
    AidTextFieldCellStylePhone,
    AidTextFieldCellStyleEmail,
    AidTextFieldCellStylePassword,
    AidTextFieldCellStyleURL,
    AidTextFieldCellStyleSelect,
    AidTextFieldCellStyleNoEnable,
};

typedef NS_ENUM(NSUInteger, AidSepratorStyle) {
    AidSepratorStyleNone = 1 << 0,
    AidSepratorStyleTop = 1 << 1,
    AidSepratorStyleBottom = 1 << 2,
};

@interface AidTextFieldCell : UITableViewCell

@property (nonatomic, assign) AidTextFieldCellStyle cellStyle;
@property (nonatomic, assign) AidSepratorStyle lineStyle;

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *valueText;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)focusTextField;
- (void)hideKeyBoard;

@end
