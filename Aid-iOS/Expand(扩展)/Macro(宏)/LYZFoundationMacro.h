//
//  LYZFoundationMacro.h
//  Aid-iOS
//
//  Created by 刘育哲 on 16/2/29.
//  Copyright © 2016年 刘育哲. All rights reserved.
//

#ifndef LYZFoundationMacro_h
#define LYZFoundationMacro_h

// block self
#define LYZWeakSelf __weak typeof(self) weakSelf = self;
#define LYZStrongSelf __strong typeof(weakSelf) strongSelf = weakSelf;

#endif /* LYZFoundationMacro_h */
