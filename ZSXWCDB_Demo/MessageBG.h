//
//  MessageBG.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/4.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageBG : NSObject

@property NSInteger localID;
@property(retain) NSDate *createTime;
@property(retain) NSDate *modifiedTime;
@property(assign) NSInteger unused;

+(BOOL)saveWithMessage:(MessageBG *)message count:(NSInteger)count;

+(void)zsx_update;

+(NSArray *)zsx_bg_findWhere;

@end

NS_ASSUME_NONNULL_END
