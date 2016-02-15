//
//  AidWeekDayView.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/6.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^weekDayAction)(NSDictionary *dictionary);

@interface AidWeekDayView : UIView

@property (nonatomic, copy) weekDayAction weekDayTouched;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *stateDictionary; /**< 星期状态字典 */

@end
