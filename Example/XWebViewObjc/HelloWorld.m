//
//  HelloWorld.m
//  XWebViewObjc_Example
//
//  Created by Futao on 2018/6/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

#import "HelloWorld.h"

@implementation HelloWorld
- (void)show:(NSString*)test {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:test message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    });
    NSLog(@"sample.helloWorld.show");
}
@end
