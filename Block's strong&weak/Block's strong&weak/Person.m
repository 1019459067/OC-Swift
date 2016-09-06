//
//  Person.m
//  Block's strong&weak
//
//  Created by STMBP on 16/8/22.
//  Copyright © 2016年 sensetime. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
