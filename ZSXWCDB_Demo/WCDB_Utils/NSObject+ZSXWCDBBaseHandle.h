//
//  NSObject+ZSXWCDBBaseHandle.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSXWCDBConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZSXWCDBBaseHandle)

/**
 获取表名
 
 @return 表名
 */
+(NSString *)GetTableName;

/**
 查询所有数据
 
 @return 对象数组
 */
+(NSArray *)zsx_SelectAllObject;

/**
 插入数据库
 
 @return 是否成功
 */
-(BOOL)zsx_insertObject;

/**
 插入或更新
 
 @return 是否成功
 */
-(BOOL)zsx_insertOrUpdateObject;

/**
 清空表内所有数据

 @return 是否成功
 */
-(BOOL)zsx_deleteAllObject;

/**
 注册数据库表变化监听.
 @tablename 表名称，当此参数为nil时，监听以当前类名为表名的数据表，当此参数非nil时，监听以此参数为表名的数据表。
 @identify 唯一标识，,此字符串唯一,不可重复,移除监听的时候使用此字符串移除.
 @return YES: 注册监听成功; NO: 注册监听失败.
 */
+(BOOL)zsx_registerChangeForTableName:(NSString* _Nullable)tablename identify:(NSString* _Nonnull)identify block:(zsx_changeBlock)block;

/**
 移除数据库表变化监听.
 @tablename 表名称，当此参数为nil时，监听以当前类名为表名的数据表，当此参数非nil时，监听以此参数为表名的数据表。
 @identify 唯一标识，,此字符串唯一,不可重复,移除监听的时候使用此字符串移除.
 @return YES: 移除监听成功; NO: 移除监听失败.
 */
+(BOOL)zsx_removeChangeForTableName:(NSString* _Nullable)tablename identify:(NSString* _Nonnull)identify;

/**
 发送数据库变化通知

 @param flag 是否执行通知
 @param state 数据库变化状态
 */
+(void)zsx_doChangeWithNameWithflag:(BOOL)flag state:(zsx_changeState)state;

@end

NS_ASSUME_NONNULL_END
