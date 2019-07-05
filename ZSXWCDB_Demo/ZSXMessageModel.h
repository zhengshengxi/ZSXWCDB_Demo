//
//  ZSXMessageModel.h
//  ZSXWCDB_Demo
//
//  Created by 郑胜昔 on 2019/7/5.
//  Copyright © 2019 郑胜昔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSXMessageModel : NSObject

@property(nonatomic, retain) NSString *property1;
@property(nonatomic, assign) NSInteger property2;
@property(nonatomic, assign) float property3;
@property(nonatomic, strong) NSArray *property4;
@property(nonatomic, readonly) NSDate *dateTime;

+(BOOL)createTable;

@end
