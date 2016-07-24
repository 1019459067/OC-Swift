//
//  NSString+WHExtension.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/24.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "NSString+WHExtension.h"

@implementation NSString (WHExtension)
- (unsigned long long)fileSize
{
//    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
//    NSString *directPath = [cachesPath stringByAppendingPathComponent:@"default"];
    
    unsigned long long size = 0;

    //manger file
    NSFileManager *mgrFile = [NSFileManager defaultManager];
    
    // judge file type
    BOOL isDirectory = NO;
    BOOL bExistPath = [mgrFile fileExistsAtPath:self isDirectory:&isDirectory];
    if (!bExistPath) return size;
    
    if (isDirectory)
    {
        //迭代器
        NSDirectoryEnumerator *enumerator = [mgrFile enumeratorAtPath:self];
        for (NSString *strSub in enumerator)
        {
            NSString *pathFull = [self stringByAppendingPathComponent:strSub];
            size += [mgrFile attributesOfItemAtPath:pathFull error:nil].fileSize;
        }
    }else
    {
        size = [mgrFile attributesOfItemAtPath:self error:nil].fileSize;
    }
    return size;
}
@end
