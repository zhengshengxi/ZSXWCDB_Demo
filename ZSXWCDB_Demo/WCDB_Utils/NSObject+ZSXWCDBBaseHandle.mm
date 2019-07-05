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
    return result;
}

@end
