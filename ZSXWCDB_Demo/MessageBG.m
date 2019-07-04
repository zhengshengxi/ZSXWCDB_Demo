//
//  MessageBG.m
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/4.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import "MessageBG.h"
#import "BGFMDB.h"

@implementation MessageBG

+(BOOL)saveWithMessage:(MessageBG *)message count:(NSInteger)count {
    bg_inTransaction(^BOOL{
        for (int i = 0; i < count; i++) {
            [message bg_save];
        }
        return YES;
    });
    return YES;
}

+(void)zsx_update {
    [self.class bg_update:@"MessageBG" where:[NSString stringWithFormat:@"set %@=%@",bg_sqlKey(@"unused"),bg_sqlValue(@(2))]];
}

+(NSArray *)zsx_bg_findWhere {
    NSString *where = [NSString stringWithFormat:@"where %@=%@",bg_sqlKey(@"bg_id"),bg_sqlValue(@(1))];
    return [MessageBG bg_find:@"MessageBG" where:where];
}

@end
