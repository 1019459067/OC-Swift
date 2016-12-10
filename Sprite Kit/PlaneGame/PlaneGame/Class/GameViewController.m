//
//  GameViewController.m
//  PlaneGame
//
//  Created by STMBP on 2016/12/7.
//  Copyright © 2016年 1019459067. All rights reserved.
//

#import "GameViewController.h"
#import "LoadingScene.h"
#import "GameScene.h"
#import "PGButton.h"
#import "HomeScene.h"
#import <AVFoundation/AVFoundation.h>
#import "PreviewView.h"
#import "FaceSDKTool.h"

#define KSCREENW [UIScreen mainScreen].bounds.size.width
#define KSCREENH [UIScreen mainScreen].bounds.size.height

@interface GameViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
{
    float _fScale;
}
@property (strong, nonatomic) NSTimer *timer;
    //for camera
@property (nonatomic , strong) AVCaptureDevice *deviceVideo;
@property (nonatomic , strong) AVCaptureSession *session;

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (strong, nonatomic) PreviewView *previewView;

@property (nonatomic) cv_handle_t hTracker;
@end

@implementation GameViewController

- (AVCaptureDevice *)deviceVideo
{
    if (!_deviceVideo)
    {
        _deviceVideo = [self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
    }
    return _deviceVideo;
}
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position
{
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices)
    {
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            if ([device position] == position)
            {
                return device;
            }
        }
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;

//    HomeScene *scene = [[HomeScene alloc]initWithSize:self.view.bounds.size];
    LoadingScene *scene = [[LoadingScene alloc]initWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gameOver) name:k_Noti_GameOver object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gamePause) name:k_Noti_Pause object:nil];

    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
    [self setupUI];
    [self initCamera];

    self.hTracker = [FaceSDKTool st_initTrackerWith320W:NO];
    if (!self.hTracker)
    {
        NSLog(@"Failed to init FaceSDK.");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed to init FaceSDK" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    [self startCamera];
}
- (void)setupUI
{
    self.previewView = [[PreviewView alloc]init];
    [self.view addSubview:self.previewView];
    self.previewView.alpha = 0;

        // 640x480 1280x720
    _fScale = 640 / KSCREENH;
    float fPreviewW = 480 / _fScale;
    float fPreviewH = KSCREENH;

    float displayScale = 1/6.;
    self.previewView.frame = CGRectMake(KSCREENW-fPreviewW*displayScale-20,
                                        20,
                                        fPreviewW*displayScale,
                                        fPreviewH*displayScale);

//    self.previewView.userInteractionEnabled = YES;
//    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
//    [self.previewView addGestureRecognizer:gestureRecognizer];

}
- (void)initCamera
{
        // Create the AVCaptureSession.
    self.session = [[AVCaptureSession alloc] init];
    self.previewView.session = self.session;

    dispatch_async(self.sessionQueue, ^{
        NSError *error = nil;

        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.deviceVideo error:&error];
        if (!videoDeviceInput) {
                // Handle the error appropriately.
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        AVCaptureVideoDataOutput * dataOutput = [[AVCaptureVideoDataOutput alloc] init];
        [dataOutput setAlwaysDiscardsLateVideoFrames:YES];
        [dataOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        [dataOutput setSampleBufferDelegate:self queue:dispatch_get_global_queue(0, 0)];


        [self.session beginConfiguration];
        if ([self.session canAddOutput:dataOutput]) {
            [self.session addOutput:dataOutput];
        }

        if ( [self.session canAddInput:videoDeviceInput] ) {
            [self.session addInput:videoDeviceInput];

            dispatch_async( dispatch_get_main_queue(), ^{

                UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
                AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
                if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
                    initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
                }
                AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
                previewLayer.connection.videoOrientation = initialVideoOrientation;
            } );
        }

        [self.session commitConfiguration];
    } );
}

#pragma mark - AVCaptureVideoDataOutputSampleBuffer Delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    uint8_t *baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer);
    cv_face_t *pFaceArray = NULL ;
    int iCount = 0;
    int iWidth  = (int)CVPixelBufferGetWidth(pixelBuffer);
    int iHeight = (int)CVPixelBufferGetHeight(pixelBuffer);

    cv_result_t iRet = CV_OK;
    iRet = cv_face_track(self.hTracker, baseAddress, CV_PIX_FMT_BGRA8888, iWidth, iHeight, iWidth * 4, CV_FACE_LEFT, &pFaceArray, &iCount);

    if (iRet == CV_OK && iCount)
    {
        cv_face_t mainFace;
        mainFace.points_count = 0;
        mainFace.rect.top = 0;
        mainFace.rect.left = 0;
        mainFace.rect.right = 0;
        mainFace.rect.bottom = 0;
        mainFace.ID = -1;
        mainFace.score = 0;
        mainFace.yaw = 0;
        mainFace.pitch = 0;
        mainFace.roll = 0;
        mainFace.eye_dist = 0;

        int iFaceWidthMax = 0;

        for (int i = 0; i < iCount ; i++)       // Pick the biggest face
        {
            cv_face_t faceInfoAll = pFaceArray[i] ;

            int iFaceWidth = (faceInfoAll.rect.right - faceInfoAll.rect.left);
            if (iFaceWidth > iFaceWidthMax)
            {
                mainFace = faceInfoAll;
                iFaceWidthMax = iFaceWidth;
            }
        }
        self.yawValue = mainFace.yaw;
        self.pitchValue = mainFace.pitch;
    }else
    {
        self.yawValue = 0;
        self.pitchValue = 0;
    }
    cv_face_release_tracker_result(pFaceArray, iCount);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}
- (NSTimer *)timer
{
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addNumber) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}
- (void)startCamera
{
    if (!self.previewView.alpha)
    {
        [UIView animateWithDuration:2. animations:^{
            self.previewView.alpha = 1;
        }];
    }
    dispatch_async(self.sessionQueue, ^{
        [self.session startRunning];
    });
}
- (void)stopCamera
{
    if (self.previewView.alpha)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.previewView.alpha = 0;
        }];
    }
    [self.session stopRunning];
}
- (void)addNumber
{
    self.iNumber = self.iNumber+1;
}
- (void)stopTime
{
    [self.timer invalidate];
    self.timer = nil;
    self.iNumber = 0;
}
- (void)startTime
{
    [self.timer setFireDate:[NSDate distantPast]];
}
- (double)yawValue
{
    return _yawValue;
}
- (double)pitchValue
{
    return _pitchValue;
}
- (int)iNumber
{
    return _iNumber;
}

- (void)gamePause
{
    ((SKView *)self.view).paused = YES;

    UIView *viewPause = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    viewPause.center = self.view.center;
    [self.view addSubview:viewPause];

    PGButton *buttonContinue = [[PGButton alloc]initWithCenter:CGPointMake(viewPause.frame.size.width/2., viewPause.frame.size.height/2.-70) bound:CGRectMake(0,0,200,40) title:@"continue" selectedTitle:nil];
    [buttonContinue didClicked:^{
        [self continueGame:buttonContinue];
    }];
    [viewPause addSubview:buttonContinue];

    PGButton *buttonRestart = [[PGButton alloc]initWithCenter:CGPointMake(viewPause.frame.size.width/2., viewPause.frame.size.height/2.) bound:CGRectMake(0,0,200,40) title:@"restart" selectedTitle:nil];
    [buttonRestart didClicked:^{
        [self restart:buttonRestart];
    }];
    [viewPause addSubview:buttonRestart];

    PGButton *buttonBack = [[PGButton alloc]initWithCenter:CGPointMake(viewPause.frame.size.width/2., viewPause.frame.size.height/2.+70) bound:CGRectMake(0,0,200,40) title:@"home" selectedTitle:nil];
    [buttonBack didClicked:^{
#warning <#message#>
//        [self onActionBack:buttonBack];
    }];
    [viewPause addSubview:buttonBack];
}
- (void)onActionBack:(PGButton *)sender
{

    HomeScene *scene = [[HomeScene alloc]initWithSize:self.view.bounds.size];
    SKTransition *tran = [SKTransition doorsCloseVerticalWithDuration:1.];
    SKView *skView = (SKView *)self.view;

    [skView presentScene:scene transition:tran];

}
- (void)continueGame:(PGButton *)sender
{
    [sender.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
}
- (void)gameOver
{
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    viewBg.center = self.view.center;
    [self.view addSubview:viewBg];

    PGButton *button = [[PGButton alloc]initWithCenter:CGPointMake(viewBg.frame.size.width/2., viewBg.frame.size.height/2.) bound:CGRectMake(0,0,200,30) title:@"restart" selectedTitle:nil];
    [button didClicked:^{
        [self restart:button];
    }];
    [viewBg addSubview:button];
}
- (void)restart:(PGButton *)sender
{
    [sender.superview removeFromSuperview];
    ((SKView *)self.view).paused = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:k_Noti_Restart object:nil];
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
