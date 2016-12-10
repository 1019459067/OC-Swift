//
//  PreviewView.m
//  SpriteWalkthrough
//
//  Created by 1019459067 on 05/12/15.
//  Copyright © 2015年 1019459067. All rights reserved.
//

#import "PreviewView.h"


@implementation PreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.session = session;
    previewLayer.session.sessionPreset = [PreviewView returnAVCaptureSessionSessionPreset];
}
+ (NSString *)returnAVCaptureSessionSessionPreset{

    NSString *tempStr = @"640x480";//[DefaultInfo shareUserInfo].strLocalCamResolution;
    if ([tempStr isEqualToString:@"640x480"]) {
        return AVCaptureSessionPreset640x480;
    }else if ([tempStr isEqualToString:@"1280x720"]){
        return  AVCaptureSessionPreset1280x720;
    }else if ([tempStr isEqualToString:@"1920x1080"]){
        return AVCaptureSessionPreset1920x1080;
    }else{
        return AVCaptureSessionPreset640x480;
    }
}
@end
