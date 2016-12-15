//
//  DefaultValue.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/11.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "DefaultValue.h"

#define k_strSound         @"k_strSound"

@interface DefaultValue ()

@property (strong, nonatomic) NSUserDefaults *userInfo;

@end
@implementation DefaultValue
@synthesize strSound = _strSound;
+ (DefaultValue *)shared
{
    static DefaultValue *userDefault;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefault = [[DefaultValue alloc]init];
    });
    return userDefault;
}
- (NSUserDefaults *)userInfo
{
    if (!_userInfo)
    {
        _userInfo = [NSUserDefaults standardUserDefaults];
    }
    return _userInfo;
}
- (void)setStrSound:(NSString *)strSound
{
    [self.userInfo setObject:strSound forKey:k_strSound];
    [self.userInfo synchronize];
}
- (NSString *)strSound
{
    _strSound = [self.userInfo objectForKey:k_strSound];
    return _strSound;
}

- (void)setDefaultValue
{
    if (!self.strSound.length)
    {
        self.strSound = @"1";
    }
    self.strSound = @"0";
}
@end
