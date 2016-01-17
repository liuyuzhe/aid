//
//  AidAgendaRecord.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/1/17.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "CTPersistanceRecord.h"

@interface AidAgendaRecord : CTPersistanceRecord

@property (nonatomic, strong) NSNumber *primaryKey; /**< 主键 */
@property (nonatomic, strong) NSString *name; /**< 名称 */
@property (nonatomic, strong) NSString *describe; /**< 描述 */
@property (nonatomic, strong) NSString *imageName; /**< 封面图像名称 */
@property (nonatomic, strong) NSNumber *createPersonID; /**< 创建者 */
@property (nonatomic, strong) NSNumber *taskCount; /**< 任务数量 */

@property (nonatomic, strong) NSNumber *createTime; /**< 创建时间 */
@property (nonatomic, strong) NSNumber *watchState; /**< 是否浏览 */
@property (nonatomic, strong) NSNumber *praiseState; /**< 是否点赞 */
@property (nonatomic, strong) NSNumber *storeState; /**< 是否收藏 */

@end
