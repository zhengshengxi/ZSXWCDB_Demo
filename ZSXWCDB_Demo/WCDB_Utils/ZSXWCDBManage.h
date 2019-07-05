//
//  ZSXWCDBManage.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>
#import "ZSXChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZSXWCDBManage : NSObject

@property (nonatomic,strong) WCTDatabase *database;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
