//
//  NSObject+ZSXWCDBBaseHandle.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@end

NS_ASSUME_NONNULL_END
