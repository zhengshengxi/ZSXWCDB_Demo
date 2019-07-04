//
//  ViewController.m
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/3.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "ViewController.h"
#import "Message.h"
#import "FMDatabase.h"

@interface ViewController () {
    dispatch_queue_t  queue;
    Message *message;
    NSMutableArray *mArr;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segC;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) WCTDatabase *database;
@property (nonatomic,strong) FMDatabase *fmdb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("com.fw.queue", DISPATCH_QUEUE_CONCURRENT);
    [self createDB];
}

-(BOOL)createDB {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    BOOL result = [self.database createTableAndIndexesOfName:@"message" withClass:Message.class];
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"创建数据库方法耗时: %f ms", endTime * 1000.0);
    
    //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
    [self.fmdb open];
    if (![self.fmdb open]) {
        NSLog(@"db open fail");
    }
    else {
        //4.数据库中创建表（可创建多张）
        NSString *sql = @"create table if not exists message ('localID' INTEGER PRIMARY KEY AUTOINCREMENT,'createTime' TEXT NOT NULL, 'modifiedTime' TEXT NOT NULL,'unused' INTEGER NOT NULL)";
        //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
        BOOL result = [self.fmdb executeUpdate:sql];
        if (result) {
            NSLog(@"create table success");
            
        }
    }
    [self.fmdb close];
    
    return result;
}

-(WCTDatabase *)database {
    if (!_database) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [NSString stringWithFormat:@"%@/%@",docDir,@"wcdb.db"];
        NSLog(@"WCDB Path: %@",path);
        _database = [[WCTDatabase alloc] initWithPath:path];
    }
    return _database;
}

-(FMDatabase *)fmdb {
    if (!_fmdb) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [NSString stringWithFormat:@"%@/%@",docDir,@"fmdb.db"];
        NSLog(@"FMDB Path: %@",path);
        //2.创建对应路径下数据库
        _fmdb = [FMDatabase databaseWithPath:path];
    }
    return _fmdb;
}

- (IBAction)insertAction:(UIButton *)sender {
    __block NSString *log;
    NSInteger count = 100000;
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    if (self.segC.selectedSegmentIndex == 0) {
        //插入
        if (!message) {
            message = [[Message alloc] init];
            message.isAutoIncrement = YES;
            //        message.localID = 1;
//            message.content = [Content new];
            message.createTime = [NSDate date];
            message.modifiedTime = [NSDate date];
            message.unused = 1;
        }
        /*
         INSERT INTO message(localID, content, createTime, modifiedTime)
         VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
         */
        
        startTime = CFAbsoluteTimeGetCurrent();
        [self.database insertObject:message into:@"message"];
        //        [self.database insertOrReplaceObject:message into:@"message"];
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log = [NSString stringWithFormat:@"WCDB插入一条数据方法耗时: %f ms\n", endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log];
        });
        dispatch_async(queue, ^{
            
        });
         return;
        
//        if (!mArr) {
//            mArr = [NSMutableArray new];
//            for (int i = 0; i < count; i++) {
//                Message *message = [[Message alloc] init];
//                //            message.localID = 1;
////                message.content = [Content new];
//                message.createTime = [NSDate date];
//                message.modifiedTime = [NSDate date];
//                message.unused = 1;
//                [mArr addObject:message];
//            }
//        }
        CFAbsoluteTime startTime2 = CFAbsoluteTimeGetCurrent();
        BOOL commited = [self.database runTransaction:^BOOL {
            for (int i = 0; i < count; i++) {
                [self.database insertObject:message into:@"message"];
            }
            return YES; //return YES to commit transaction and return NO to rollback transaction.
        }];
        CFAbsoluteTime endTime2 = (CFAbsoluteTimeGetCurrent() - startTime2);
        NSString *log2 = [NSString stringWithFormat:@"WCDB插入%ld条数据方法耗时: %f ms\n\n",count, endTime2 * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log2];
        });
        
        [self scrollToBottom];
        dispatch_async(queue, ^{
            
            
            //            [self.database insertObjects:mArr into:@"message"];
            
        });
    }
    else {
        startTime = CFAbsoluteTimeGetCurrent();
        [self.fmdb open];
        
        //1.开启事务
//        [self.fmdb beginTransaction];
        BOOL result = [self.fmdb executeUpdate:@"insert into 'message'(createTime,modifiedTime,unused) values(?,?,?)" withArgumentsInArray:@[[NSDate date],[NSDate date],@1]];
        if (result) {
            
        } else {
            
        }
//        [self.fmdb commit];
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log = [NSString stringWithFormat:@"FMDB插入一条数据方法耗时: %f ms\n", endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log];
        });
        return;
        CFAbsoluteTime startTime2 = CFAbsoluteTimeGetCurrent();
        //1.开启事务
        [self.fmdb beginTransaction];
        for (int i = 0; i < count; i++) {
            BOOL result = [self.fmdb executeUpdate:@"insert into 'message'(createTime,modifiedTime,unused) values(?,?,?)" withArgumentsInArray:@[[NSDate date],[NSDate date],@1]];
        }
        [self.fmdb commit];
        CFAbsoluteTime endTime2 = (CFAbsoluteTimeGetCurrent() - startTime2);
        NSString *log2 = [NSString stringWithFormat:@"FMDB插入%ld条数据方法耗时: %f ms\n\n",count , endTime2 * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log2];
        });
        
        [self.fmdb close];
        [self scrollToBottom];
    }
}

- (IBAction)btnDelectAction:(UIButton *)sender {
    if (self.segC.selectedSegmentIndex == 0) {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        NSNumber *count = [self.database getOneValueOnResult:Message.AnyProperty.count()
                                                   fromTable:@"message"];
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log = [NSString stringWithFormat:@"WCDB查询表count耗时: %f ms\n", endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log];
        });
        startTime = CFAbsoluteTimeGetCurrent();
        [self.database deleteAllObjectsFromTable:@"message"];
        endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log2 = [NSString stringWithFormat:@"WCDB清除%@条数据方法耗时: %f ms\n\n", count, endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log2];
        });
    }
    else {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        [self.fmdb open];
        FMResultSet *result = [self.fmdb executeQuery:@"SELECT count(*) FROM message"];
        NSInteger count = 0;
        if ([result next]) {
            count = [result intForColumnIndex:0];
        }
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log = [NSString stringWithFormat:@"FMDB查询表count耗时: %f ms\n", endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log];
        });
        
        startTime = CFAbsoluteTimeGetCurrent();
        [self.fmdb executeUpdate:@"DELETE FROM message"];
        [self.fmdb close];
        endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log2 = [NSString stringWithFormat:@"FMDB清除%ld条数据方法耗时: %f ms\n\n", count, endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log2];
        });
    }
    
    [self scrollToBottom];
}

- (IBAction)btnUpdateAction:(UIButton *)sender {
    if (self.segC.selectedSegmentIndex == 0) {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        NSNumber *count = [self.database getOneValueOnResult:Message.AnyProperty.count() fromTable:@"message"];
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log = [NSString stringWithFormat:@"查询表count耗时: %f ms\n", endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log];
        });
        
        startTime = CFAbsoluteTimeGetCurrent();
        [self.database updateAllRowsInTable:@"message" onProperty:Message.unused withValue:@(2)];
        endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log2 = [NSString stringWithFormat:@"更新%@条数据耗时: %f ms\n\n", count, endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log2];
        });
    }
    else {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        [self.fmdb open];
        FMResultSet *result = [self.fmdb executeQuery:@"SELECT count(*) FROM message"];
        NSInteger count = 0;
        if ([result next]) {
            count = [result intForColumnIndex:0];
        }
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log = [NSString stringWithFormat:@"FMDB查询表count耗时: %f ms\n", endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log];
        });
        
        startTime = CFAbsoluteTimeGetCurrent();
        [self.fmdb executeUpdate:@"UPDATE message SET unused = 2"];
        [self.fmdb close];
        endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSString *log2 = [NSString stringWithFormat:@"FMDB更新%ld条数据方法耗时: %f ms\n\n", count, endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log2];
        });
    }
    
    [self scrollToBottom];
}

- (IBAction)btnSelectAction:(UIButton *)sender {
    __block NSString *log;
    if (self.segC.selectedSegmentIndex == 0) {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
            NSArray *arr = [self.database getAllObjectsOfClass:Message.class fromTable:@"message"];
//        NSArray *arr = [self.database getObjectsOfClass:Message.class fromTable:@"message" where:Message.localID==740942];
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        log = [NSString stringWithFormat:@"WCDB查询%ld条数据耗时: %f ms\n\n", arr.count, endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log];
        });
    }
    else {
        CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
        [self.fmdb open];
        FMResultSet *result = [self.fmdb executeQuery:@"select * from 'message'"];
//        FMResultSet *result = [self.fmdb executeQuery:@"select * from 'message' where localID = ?" withArgumentsInArray:@[@(823346)]];
        NSMutableArray *mArr = [NSMutableArray new];
        while ([result next]) {
            NSMutableDictionary *mDic = [NSMutableDictionary new];
            [mDic setValue:@([result intForColumn:@"localID"]) forKey:@"localID"];
            [mDic setValue:[result dateForColumn:@"createTime"] forKey:@"createTime"];
            [mDic setValue:[result dateForColumn:@"modifiedTime"] forKey:@"modifiedTime"];
            [mDic setValue:@([result intForColumn:@"unused"]) forKey:@"unused"];
            [mArr addObject:mDic];
        }
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        log = [NSString stringWithFormat:@"FMDB查询%ld条数据耗时: %f ms\n\n", mArr.count, endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log];
        });
    }
    
    [self scrollToBottom];
}

-(void)scrollToBottom {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 0)];
    });
}

@end
