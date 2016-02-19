//
//  AidTaskRecord.h
//  Aid-iOS
//
//  Created by 刘育哲 on 15/11/22.
//  Copyright © 2015年 刘育哲. All rights reserved.
//

#import "CTPersistanceRecord.h"

@interface AidTaskRecord : CTPersistanceRecord

@property (nonatomic, strong) NSNumber *primaryKey; /**< 主键 */
@property (nonatomic, strong) NSString *name; /**< 名称 */
@property (nonatomic, strong) NSNumber *startTime; /**< 开始时间 */
@property (nonatomic, strong) NSNumber *endTime; /**< 结束时间 */
@property (nonatomic, strong) NSNumber *alarmTime; /**< 提醒时间 */
@property (nonatomic, strong) NSString *repeat; /**< 重复周期 */
@property (nonatomic, strong) NSString *note; /**< 备注 */
@property (nonatomic, strong) NSNumber *priority; /**< 优先级 */
@property (nonatomic, strong) NSNumber *themeID; /**< 主题ID */

@end
