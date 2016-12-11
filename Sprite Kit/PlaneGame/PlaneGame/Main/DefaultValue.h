//
//  DefaultValue.h
//  PlaneGame
//
//  Created by STMBP on 2016/12/11.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultValue : NSObject


/**
 生意开关
 */
@property (copy, nonatomic) NSString *strSound;


+ (DefaultValue *)shared;

- (void)setDefaultValue;
@end
