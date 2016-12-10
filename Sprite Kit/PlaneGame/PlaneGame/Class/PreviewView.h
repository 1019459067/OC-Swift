//
//  PreviewView.h
//  SpriteWalkthrough
//
//  Created by 1019459067 on 05/12/15.
//  Copyright © 2015年 1019459067. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AVCaptureSession;
@interface PreviewView : UIImageView

@property (nonatomic) AVCaptureSession *session;

@end
