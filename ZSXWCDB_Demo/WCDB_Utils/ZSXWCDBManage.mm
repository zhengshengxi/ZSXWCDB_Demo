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

-(NSMutableDictionary *)changeBlocks {
    if (!_changeBlocks) {
        _changeBlocks = [NSMutableDictionary dictionary];
    }
    return _changeBlocks;
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

/**
 注册数据变化监听.
 */
-(BOOL)registerChangeWithName:(NSString* const _Nonnull)name block:(zsx_changeBlock)block {
    if ([self.changeBlocks.allKeys containsObject:name]){
        NSString* reason = [NSString stringWithFormat:@"%@表注册监听重复,注册监听失败!",name];
        NSLog(@"%@",reason);
        return NO;
    }else{
        [self.changeBlocks setObject:block forKey:name];
        return YES;
    }
}
/**
 移除数据变化监听.
 */
-(BOOL)removeChangeWithName:(NSString* const _Nonnull)name {
    if ([self.changeBlocks.allKeys containsObject:name]){
        [self.changeBlocks removeObjectForKey:name];
        return YES;
    }else{
        NSString* reason = [NSString stringWithFormat:@"%@表还没有注册监听,移除监听失败!",name];
        NSLog(@"%@",reason);
        return NO;
    }
}

-(void)doChangeWithName:(NSString* const _Nonnull)name flag:(BOOL)flag state:(zsx_changeState)state {
    if (flag && self.changeBlocks.count>0) {
        //开一个子线程去执行block,防止死锁.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{
            [self.changeBlocks enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop){
                NSString* tablename = [key componentsSeparatedByString:@"*"].firstObject;
                if([name isEqualToString:tablename]){
                    void(^block)(NSInteger) = obj;
                    //返回主线程回调.
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        block(state);
                    });
                }
            }];
        });
    }
}

@end
