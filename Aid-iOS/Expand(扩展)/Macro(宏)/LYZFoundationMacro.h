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
#define LYZWeakSelf \
__weak typeof(self) weakSelf = self;

#define LYZStrongSelf \
__strong typeof(weakSelf) strongSelf = weakSelf;

// http://blog.sunnyxx.com/2014/09/15/objc-attribute-cleanup/
#define LYZOnExit \
__strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#ifndef NS_OPTIONS
#define NS_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#endif

// dispatch_main_sync_safe(^{
// });
//
#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

void dispatchOnMainSyncSafe(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

void dispatchOnMainAsyncSafe(dispatch_block_t block)
{
    if ([NSThread isMainThread]) {
        block();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

#endif /* LYZFoundationMacro_h */
