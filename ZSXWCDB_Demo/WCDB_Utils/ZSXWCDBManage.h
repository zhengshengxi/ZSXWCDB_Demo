//
//  ZSXWCDBManage.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>
#import "ZSXChatModel.h"
#import "ZSXWCDBConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSXWCDBManage : NSObject

@property (nonatomic,strong) WCTDatabase *database;

/**
 记录注册监听数据变化的block.
 */
@property (nonatomic,strong) NSMutableDictionary* changeBlocks;

+ (instancetype)sharedInstance;

/**
 注册数据变化监听.
 */
-(BOOL)registerChangeWithName:(NSString* const _Nonnull)name block:(zsx_changeBlock)block;

/**
 移除数据变化监听.
 */
-(BOOL)removeChangeWithName:(NSString* const _Nonnull)name;

/**
 数据库变化通知

 @param name 注册名称
 @param flag 是否执行通知
 @param state 数据变化状态
 */
-(void)doChangeWithName:(NSString* const _Nonnull)name flag:(BOOL)flag state:(zsx_changeState)state;

@end

NS_ASSUME_NONNULL_END
