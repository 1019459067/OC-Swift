//
//  Person.m
//  Block
//
//  Created by 肖伟华 on 16/7/3.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "Person.h"

@implementation Person
- (void)eat:(void (^)())block
{
    block();
}

- (void (^)(int meter))run
{
    return ^(int meter){
        NSLog(@"run meter: %d",meter * 4);
    };
}
@end
