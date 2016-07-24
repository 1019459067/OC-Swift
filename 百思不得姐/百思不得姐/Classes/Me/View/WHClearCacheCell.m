//
//  WHClearCacheCell.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/24.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHClearCacheCell.h"
#import "SDImageCache.h"
#import "SVProgressHUD.h"

#define WHCustomCacheFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"Custom"]

@implementation WHClearCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIActivityIndicatorView *loadView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadView startAnimating];
        self.accessoryView = loadView;
        self.textLabel.text = @"清除缓存(正在计算大小)";
        
        //禁止点击
        self.userInteractionEnabled = NO;
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
//            [NSThread sleepForTimeInterval:3];
            
            unsigned long long size = WHCustomCacheFile.fileSize;
            size += [SDImageCache sharedImageCache].getSize;
            //    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
            //    NSString *directPath = [cachesPath stringByAppendingPathComponent:@"default"];

            //若cell销毁,则直接返回
            if (weakSelf == nil) return ;

            NSString *sizeText = nil;
            if (size >= pow(10, 9)) { // size >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // 1KB > size
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.textLabel.text = [NSString stringWithFormat:@"清除缓存(%@)",sizeText];
                weakSelf.accessoryView = nil;
                weakSelf.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                [weakSelf addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:weakSelf action:@selector(clearCache)]];
                weakSelf.userInteractionEnabled = YES;
            });
        });
        
    }
    return self;
}
- (void)dealloc
{
    WHLogFunc
}
/**清除缓存*/
- (void)clearCache
{
    WHLogFunc
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"正在清除缓存..."];
    //clear SDWebImage cache
    [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //clear custom cache
            NSFileManager *mgr = [NSFileManager defaultManager];
            [mgr removeItemAtPath:WHCustomCacheFile error:nil];
            [mgr createDirectoryAtPath:WHCustomCacheFile withIntermediateDirectories:YES attributes:nil error:nil];

//            [NSThread sleepForTimeInterval:3];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                self.textLabel.text = @"清除缓存(0B)";
            });
        });
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
