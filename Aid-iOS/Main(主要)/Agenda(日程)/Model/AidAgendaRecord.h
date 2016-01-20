//
//  AidAgendaRecord.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "CTPersistanceRecord.h"
#import "AidAgendaThemeRecord.h"
#import "AidAgendaTaskRecord.h"

@interface AidAgendaRecord : NSObject

@property (nonatomic, strong) NSNumber *primaryKey; /**< 主键 */
@property (nonatomic, strong) AidAgendaThemeRecord *themeRecord; /**< 主题 */
@property (nonatomic, strong) NSArray<AidAgendaTaskRecord *> *tasksRecord; /**< 任务 */

@end
