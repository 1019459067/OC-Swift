//
//  WHSeeBigViewController.m
//  百思不得姐
//
//  Created by XWH on 16/08/09.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHSeeBigViewController.h"
#import "WHTopic.h"
#import "UIImageView+WebCache.h"

#import <Photos/Photos.h>
#import "SVProgressHUD.h"

@interface WHSeeBigViewController () <UIScrollViewDelegate>
/** 图片控件 */
@property (nonatomic, weak) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation WHSeeBigViewController

static NSString * WHAssetCollectionTitle = @"百思不得姐";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:scrollView atIndex:0];
        
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) return; // 图片下载失败
        self.saveButton.enabled = YES;
    }];
    [scrollView addSubview:imageView];
    
    imageView.wh_width = scrollView.wh_width;
    imageView.wh_height = self.topic.height * imageView.wh_width / self.topic.width;
    imageView.wh_x = 0;
    
    if (imageView.wh_height >= scrollView.wh_height)
    { // 图片高度超过整个屏幕
        imageView.wh_y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.wh_height);
    }else
    { // 居中显示
        imageView.wh_centerY = scrollView.wh_height * 0.5;
    }
    self.imageView = imageView;

    // 缩放比例
    CGFloat scale =  self.topic.width / imageView.wh_width;
    if (scale > 1.0)
    {
        scrollView.maximumZoomScale = scale;
    }
}

- (IBAction)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save
{
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
        [SVProgressHUD showErrorWithStatus:@"因为系统原因, 无法访问相册"];
    } else if (status == PHAuthorizationStatusDenied) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请在隐私设置中打开相机授权" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册(用户当初点击了"好")
        [self saveImage];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                [self saveImage];
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)saveImage
{
    __block NSString *assetLocalIdentifier = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存图片A到"相机胶卷"中
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success == NO) {
            [self showError:@"保存图片[视频]失败!"];
            return;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = [self createdAssetCollection];
        if (createdAssetCollection == nil) {
            [self showError:@"创建相簿失败!"];
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 3.添加"相机胶卷"中的图片A到"相簿"D中
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            
            // 添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 添加图片到相簿
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success == NO) {
                [self showError:@"保存图片[视频]失败!"];
            } else {
                [self showSuccess:@"保存图片[视频]成功!"];
            }
        }];
    }];
}

/**
 *  获得相簿
 */
- (PHAssetCollection *)createdAssetCollection
{
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:WHAssetCollectionTitle]) {
            return assetCollection;
        }
    }

    // 错误信息
    __block NSString *assetCollectionLocalIdentifier = nil;
    
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:WHAssetCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    // 如果有错误信息
    if (error) return nil;
    
    // 获得刚才创建的相簿
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}

- (void)showSuccess:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:text];
    });
}

- (void)showError:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:text];
    });
}

#pragma mark - UIScrollViewDelegate
/**
 *  返回一个scrollView的子控件进行缩放
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
