//
//  AidDiscoverThemeRecord.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/19.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#import "CTPersistanceRecord.h"

@interface AidDiscoverThemeRecord : CTPersistanceRecord

@property (nonatomic, strong) NSNumber *primaryKey; /**< 主键 */
@property (nonatomic, strong) NSString *name; /**< 名称 */
@property (nonatomic, strong) NSString *describe; /**< 描述 */
@property (nonatomic, strong) NSString *imageName; /**< 封面图像名称 */

@property (nonatomic, strong) NSNumber *createTime; /**< 创建时间 */
@property (nonatomic, strong) NSNumber *praiseState; /**< 是否点赞 */
@property (nonatomic, strong) NSNumber *watchCount; /**< 浏览数量 */
@property (nonatomic, strong) NSNumber *praiseCount; /**< 点赞数量 */
@property (nonatomic, strong) NSNumber *storeCount; /**< 收藏数量 */

@end
