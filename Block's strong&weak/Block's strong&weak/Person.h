//
//  Person.h
//  Block's strong&weak
//
//  Created by STMBP on 16/8/22.
//  Copyright © 2016年 sensetime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) void (^block)();

@end
