//
//  WHTopicPictureView.m
//  百思不得姐
//
//  Created by XWH on 15/9/16.
//  Copyright (c) 2016年 XWH. All rights reserved.
//

#import "WHTopicPictureView.h"
#import "WHTopic.h"
#import "UIImageView+WebCache.h"
#import "DALabeledCircularProgressView.h"
#import "WHSeeBigViewController.h"
#import "Reachability.h"

@interface WHTopicPictureView()
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPictureButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@end

@implementation WHTopicPictureView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    self.progressView.roundedCorners = 5;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
    
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBig)]];
}

- (void)seeBig
{
    WHSeeBigViewController *seeBig = [[WHSeeBigViewController alloc] init];
    seeBig.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBig animated:YES completion:nil];
}

- (void)setTopic:(WHTopic *)topic
{
    _topic = topic;
    // 下载图片
//    WHWeakSelf;
    if ([[UIDevice currentDevice].name isEqualToString:@"iPhone Simulator"])
    {
        [self showImageView:topic.large_image];
    }else
    {
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus status = [reachability currentReachabilityStatus];
        switch (status) {
            case ReachableViaWiFi:
                [self showImageView:topic.large_image];
                break;
            case ReachableViaWWAN:
                [self showImageView:topic.small_image];
                break;
            default:
                self.imageView.image = nil;
                break;
        }
    }
    
    self.gifView.hidden = !topic.is_gif;
    
    if (topic.isBigPicture)
    {
        self.seeBigPictureButton.hidden = NO;
        self.imageView.contentMode = UIViewContentModeTop;
        self.imageView.clipsToBounds = YES;
    }else
    {
        self.seeBigPictureButton.hidden = YES;
        self.imageView.clipsToBounds = NO;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    
//    WHWeakSelf;
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        // 每下载一点图片数据，就会调用一次这个block
//        weakSelf.progressView.hidden = NO;
//        weakSelf.progressView.progress = 1.0 * receivedSize / expectedSize;
//        weakSelf.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", weakSelf.progressView.progress * 100];
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        // 当图片下载完毕后，就会调用这个block
//        weakSelf.progressView.hidden = YES;
//    }];
//    
//    // gif
//    self.gifView.hidden = !topic.is_gif;
//    
//    // see big
//    self.seeBigPictureButton.hidden = !topic.isBigPicture;
//    if (topic.isBigPicture) {
//        _imageView.contentMode = UIViewContentModeTop;
//        _imageView.clipsToBounds = YES;
//    } else {
//        _imageView.contentMode = UIViewContentModeScaleToFill;
//        _imageView.clipsToBounds = NO;
//    }
}
- (void)showImageView:(NSString *)imageUrl
{
    [self.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        self.progressView.progress = 1.0 * receivedSize / expectedSize;
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", self.progressView.progress * 100];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
}
@end
