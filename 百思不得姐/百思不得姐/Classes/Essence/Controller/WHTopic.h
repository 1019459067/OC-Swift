 //
//  WHTopic.h
//  百思不得姐
//
//  Created by STMBP on 16/7/25.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHTopic : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *profile_image;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *created_at;
@property (assign, nonatomic) NSInteger ding;
@property (assign, nonatomic) NSInteger cai;
@property (assign, nonatomic) NSInteger repost;
@property (assign, nonatomic) NSInteger comment;

@end
