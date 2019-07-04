//
//  Message.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/3.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Content.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface Message : NSObject<WCTTableCoding>

@property NSInteger localID;
@property(retain) NSDate *createTime;
@property(retain) NSDate *modifiedTime;
@property(assign) NSInteger unused;
//@property(nonatomic,strong) Content *content;

WCDB_PROPERTY(localID)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(modifiedTime)
WCDB_PROPERTY(unused)
//WCDB_PROPERTY(content)

@end

NS_ASSUME_NONNULL_END
