//
//  ViewController.m
//  GameKit
//
//  Created by 肖伟华 on 16/7/10.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>

@interface ViewController ()<GKPeerPickerControllerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageViewShow;
@property (strong, nonatomic) GKSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onActionConnect:(UIButton *)sender {
    
    GKPeerPickerController *picker = [[GKPeerPickerController alloc]init];
    picker.delegate = self;
    [picker show];
}
- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type
{
    NSLog(@"function: %s, type: %lu",__func__,(unsigned long)type);
}
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    [picker dismiss];
    
    self.session = session;
    
    [self.session setDataReceiveHandler:self withContext:nil];
    
    
}
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    UIImage *img = [UIImage imageWithData:data];
    self.imageViewShow.image = img;
}
 -(void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    
}
- (IBAction)onActionSelectImg:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.imageViewShow.image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onActionSendImg:(id)sender {
    if (self.imageViewShow.image) {
        NSData *dataImg = UIImagePNGRepresentation(self.imageViewShow.image);
        NSError *error;
        [self.session sendDataToAllPeers:dataImg withDataMode:GKSendDataReliable error:&error];
    }
}

@end
