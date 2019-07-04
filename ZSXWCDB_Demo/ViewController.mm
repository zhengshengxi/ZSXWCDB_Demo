//
//  ViewController.m
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/3.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "ViewController.h"
#import "Message.h"

@interface ViewController () {
    dispatch_queue_t  queue;
    Message *message;
    NSMutableArray *mArr;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) WCTDatabase *database;

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
    return result;
}

-(WCTDatabase *)database {
    if (!_database) {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [NSString stringWithFormat:@"%@/%@",docDir,@"wcdb.db"];
        NSLog(@"DB Path: %@",path);
        _database = [[WCTDatabase alloc] initWithPath:path];
    }
    return _database;
}

- (IBAction)insertAction:(UIButton *)sender {
    __block NSString *log;
    //插入
    if (!message) {
        message = [[Message alloc] init];
        message.isAutoIncrement = YES;
//        message.localID = 1;
        message.content = [Content new];
        message.createTime = [NSDate date];
        message.modifiedTime = [NSDate date];
    }
    /*
     INSERT INTO message(localID, content, createTime, modifiedTime)
     VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
     */
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    __block CFAbsoluteTime endTime;
    dispatch_async(queue, ^{
        [self.database insertObject:message into:@"message"];
        //        [self.database insertOrReplaceObject:message into:@"message"];
        CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
        log = [NSString stringWithFormat:@"插入一条数据方法耗时: %f ms\n", endTime * 1000.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.textView insertText:log];
        });
    });
    
    NSInteger count = 10000;
    if (!mArr) {
        mArr = [NSMutableArray new];
        for (int i = 0; i < count; i++) {
            Message *message = [[Message alloc] init];
//            message.localID = 1;
            message.content = [Content new];
            message.createTime = [NSDate date];
            message.modifiedTime = [NSDate date];
            [mArr addObject:message];
        }
    }
    CFAbsoluteTime startTime2 = CFAbsoluteTimeGetCurrent();
    dispatch_async(queue, ^{
        BOOL commited = [self.database runTransaction:^BOOL {
            for (int i = 0; i < count; i++) {
                [self.database insertObject:message into:@"message"];
            }
            CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime2);
            log = [NSString stringWithFormat:@"插入%ld条数据方法耗时: %f ms\n\n",count, endTime * 1000.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.textView insertText:log];
            });
            
            [self scrollToBottom];
            return YES; //return YES to commit transaction and return NO to rollback transaction.
        }];
        
        //            [self.database insertObjects:mArr into:@"message"];
        
    });
}

- (IBAction)btnDelectAction:(UIButton *)sender {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSNumber *count = [self.database getOneValueOnResult:Message.AnyProperty.count()
                                          fromTable:@"message"];
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSString *log = [NSString stringWithFormat:@"查询表count耗时: %f ms\n", endTime * 1000.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView insertText:log];
    });
    startTime = CFAbsoluteTimeGetCurrent();
    [self.database deleteAllObjectsFromTable:@"message"];
    endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSString *log2 = [NSString stringWithFormat:@"清除%@条数据方法耗时: %f ms\n\n", count, endTime * 1000.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView insertText:log2];
    });
    
    [self scrollToBottom];
}

- (IBAction)btnUpdateAction:(UIButton *)sender {
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    NSNumber *count = [self.database getOneValueOnResult:Message.AnyProperty.count() fromTable:@"message"];
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSString *log = [NSString stringWithFormat:@"查询表count耗时: %f ms\n", endTime * 1000.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView insertText:log];
    });
    
    startTime = CFAbsoluteTimeGetCurrent();
    [self.database updateAllRowsInTable:@"message" onProperty:Message.content withValue:[Content new]];
    endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSString *log2 = [NSString stringWithFormat:@"更新%@条数据耗时: %f ms\n\n", count, endTime * 1000.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView insertText:log2];
    });
    
    [self scrollToBottom];
}

- (IBAction)btnSelectAction:(UIButton *)sender {
    __block NSString *log;
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
//    NSArray *arr = [self.database getAllObjectsOfClass:Message.class fromTable:@"message"];
    NSArray *arr = [self.database getObjectsOfClass:Message.class fromTable:@"message" where:Message.content.like("text")];
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    log = [NSString stringWithFormat:@"查询%ld条数据耗时: %f ms\n\n", arr.count, endTime * 1000.0];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView insertText:log];
    });
    [self scrollToBottom];
}

-(void)scrollToBottom {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 0)];
    });
}

@end
