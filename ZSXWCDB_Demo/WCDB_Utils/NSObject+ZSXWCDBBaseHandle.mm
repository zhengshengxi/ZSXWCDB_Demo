//
//  NSObject+ZSXWCDBBaseHandle.m
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "NSObject+ZSXWCDBBaseHandle.h"
#import "ZSXWCDBManage.h"

@interface NSObject () <WCTTableCoding>

@end

@implementation NSObject (ZSXWCDBBaseHandle)

+(NSString *)GetTableName {
    return [NSString stringWithFormat:@"%@",NSStringFromClass([self class])];
}

/**
 查询所有数据
 
 @return 对象数组
 */
+(NSArray *)zsx_SelectAllObject {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSArray *arrResult = [[ZSXWCDBManage sharedInstance].database getAllObjectsOfClass:self.class fromTable:[self.class GetTableName]];
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"查询%ld条(%@)数据耗时: %f ms", arrResult.count, [self.class GetTableName], endTime * 1000.0);
    return arrResult;
}

/**
 插入数据库
 
 @return 是否成功
 */
-(BOOL)zsx_insertObject {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    BOOL result = [[ZSXWCDBManage sharedInstance].database insertObject:self into:[self.class GetTableName]];
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"插入一条(%@)数据(%@)耗时: %f ms", [self.class GetTableName], result?@"success":@"failure" , endTime * 1000.0);
    [self.class zsx_doChangeWithNameWithflag:result state:zsx_insert];
    return result;
}

/**
 插入或更新
 
 @return 是否成功
 */
-(BOOL)zsx_insertOrUpdateObject {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    BOOL result = [[ZSXWCDBManage sharedInstance].database insertOrReplaceObject:self into:[self.class GetTableName]];
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"插入或更新一条(%@)数据(%@)耗时: %f ms", [self.class GetTableName], result?@"success":@"failure" , endTime * 1000.0);
    [self.class zsx_doChangeWithNameWithflag:result state:zsx_insert];
    return result;
}

/**
 清空表内所有数据
 
 @return 是否成功
 */
-(BOOL)zsx_deleteAllObject {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    BOOL result = [[ZSXWCDBManage sharedInstance].database deleteAllObjectsFromTable:[self.class GetTableName]];
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"清空表(%@)内所有数据(%@)耗时: %f ms", [self.class GetTableName], result?@"success":@"failure" , endTime * 1000.0);
    [self.class zsx_doChangeWithNameWithflag:result state:zsx_delete];
    return result;
}

/**
 注册数据库表变化监听.
 @tablename 表名称，当此参数为nil时，监听以当前类名为表名的数据表，当此参数非nil时，监听以此参数为表名的数据表。
 @identify 唯一标识，,此字符串唯一,不可重复,移除监听的时候使用此字符串移除.
 @return YES: 注册监听成功; NO: 注册监听失败.
 */
+(BOOL)zsx_registerChangeForTableName:(NSString* _Nullable)tablename identify:(NSString* _Nonnull)identify block:(zsx_changeBlock)block {
    NSAssert(identify && identify.length,@"唯一标识不能为空!");
    if (tablename == nil) {
        tablename = NSStringFromClass([self class]);
    }
    tablename = [NSString stringWithFormat:@"%@*%@",tablename,identify];
    return [[ZSXWCDBManage sharedInstance] registerChangeWithName:tablename block:block];
}

/**
 移除数据库表变化监听.
 @tablename 表名称，当此参数为nil时，监听以当前类名为表名的数据表，当此参数非nil时，监听以此参数为表名的数据表。
 @identify 唯一标识，,此字符串唯一,不可重复,移除监听的时候使用此字符串移除.
 @return YES: 移除监听成功; NO: 移除监听失败.
 */
+(BOOL)zsx_removeChangeForTableName:(NSString* _Nullable)tablename identify:(NSString* _Nonnull)identify {
    NSAssert(identify && identify.length,@"唯一标识不能为空!");
    if (tablename == nil) {
        tablename = NSStringFromClass([self class]);
    }
    tablename = [NSString stringWithFormat:@"%@*%@",tablename,identify];
    return [[ZSXWCDBManage sharedInstance] removeChangeWithName:tablename];
}

+(void)zsx_doChangeWithNameWithflag:(BOOL)flag state:(zsx_changeState)state {
    [[ZSXWCDBManage sharedInstance] doChangeWithName:[self GetTableName] flag:flag state:state];
}

@end
