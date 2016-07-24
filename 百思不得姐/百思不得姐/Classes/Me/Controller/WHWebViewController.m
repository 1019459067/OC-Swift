//
//  WHWebViewController.m
//  百思不得姐
//
//  Created by 肖伟华 on 16/7/24.
//  Copyright © 2016年 XWH. All rights reserved.
//

#import "WHWebViewController.h"

@interface WHWebViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemRewind;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *itemForward;

@end

@implementation WHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.itemRewind.enabled = webView.canGoBack;
    self.itemForward.enabled = webView.canGoForward;
}
#pragma mark --  button Action
- (IBAction)onActionBack:(UIBarButtonItem *)sender {
    [self.webView goBack];
}
- (IBAction)onActionForWard:(UIBarButtonItem *)sender {
    [self.webView goForward];
}
- (IBAction)onActionRefresh:(UIBarButtonItem *)sender {
    [self.webView reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
