//
//  ViewController.m
//  XWebViewObjc_Example
//
//  Created by Futao on 2018/6/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

#import "ViewController.h"
#import <XWebViewObjc/XWebViewObjc-Swift.h>
#import "WebKit/WebKit.h"
#import "Echo.h"
#import "Vibrate.h"
#import "HelloWorld.h"
#import "XXEcho.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:[WKWebViewConfiguration new]];
    [self.view addSubview:webView];
    [webView loadPlugin:[[XXEcho alloc] init] namespace:@"window.XXEcho"];
    [webView loadPlugin:[[Echo alloc] initWithPrefix:@""] namespace:@"sample.Echo"];
    [webView loadPlugin:[[HelloWorld alloc] init] namespace:@"sample.hello"];
    [webView loadPlugin:[[Vibrate alloc] init] namespace:@"sample.vibrate"];
    NSString *htmlURLPath =  [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfFile:htmlURLPath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:html baseURL:[NSBundle mainBundle].resourceURL];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
