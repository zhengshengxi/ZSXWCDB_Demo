//
//  ZSXWCDBManage.m
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "ZSXWCDBManage.h"

@implementation ZSXWCDBManage

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//-(instancetype)init {
//    if (self == [super init]) {
//        [WCTStatistics SetGlobalSQLTrace:^(NSString *sql) {
//            NSLog(@"SQL: %@", sql);
//        }];
//        [WCTStatistics SetGlobalPerformanceTrace:^(WCTTag tag, NSDictionary<NSString*, NSNumber*>* sqls, NSInteger cost) {
//            NSLog(@"Tag: %d", tag);
//            [sqls enumerateKeysAndObjectsUsingBlock:^(NSString *sql, NSNumber *count, BOOL *) {
//                NSLog(@"SQL: %@ Count: %d", sql, count.intValue);
//            }];
//            NSLog(@"Total cost %ld nanoseconds", (long)cost);
//        }];
//    }
//    return self;
//}

-(WCTDatabase *)database {
    if (!_database) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [NSString stringWithFormat:@"%@/%@",docDir,@"wcdb.db"];
        NSLog(@"WCDB Path: %@",path);
        _database = [[WCTDatabase alloc] initWithPath:path];
        //数据库加密
        NSData *password = [@"123456" dataUsingEncoding:NSASCIIStringEncoding];
        [_database setCipherKey:password];
        //创建表
        [self createDBWithClass:[ZSXChatModel class]];
    }
    return _database;
}

-(BOOL)createDBWithClass:(Class)objectClass {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    BOOL result = NO;
    if ([objectClass respondsToSelector:@selector(GetTableName)]) {
        if (![self.database isTableExists:[objectClass performSelector:@selector(GetTableName)]]) {
            result = [self.database createTableAndIndexesOfName:NSStringFromClass(objectClass) withClass:objectClass];
            CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
            NSLog(@"创建数据库表:%@ 耗时: %f ms", NSStringFromClass(objectClass), endTime * 1000.0);
        }
        else {
            CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
            NSLog(@"已存在数据库表:%@ 耗时: %f ms", NSStringFromClass(objectClass),endTime * 1000.0);
            result = YES;
        }
    }
    return result;
}

@end
