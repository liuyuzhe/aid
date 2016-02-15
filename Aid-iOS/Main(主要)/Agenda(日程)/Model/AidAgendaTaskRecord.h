//
//  AidAgendaTaskRecord.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/18.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "CTPersistanceRecord.h"

@interface AidAgendaTaskRecord : CTPersistanceRecord

@property (nonatomic, strong) NSNumber *primaryKey; /**< 主键 */
@property (nonatomic, strong) NSString *name; /**< 名称 */
@property (nonatomic, strong) NSNumber *startTime; /**< 开始时间 */
@property (nonatomic, strong) NSNumber *completeTime; /**< 完成时间 */
@property (nonatomic, strong) NSNumber *alarmTime; /**< 提醒时间 */
@property (nonatomic, strong) NSNumber *repeatTime; /**< 重复频率 */
@property (nonatomic, strong) NSNumber *completeState; /**< 是否完成 */
@property (nonatomic, strong) NSNumber *priority; /**< 优先级 */

@end
