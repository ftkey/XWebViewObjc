//
//  Echo.m
//  XWebViewObjc_Example
//
//  Created by Futao on 2018/6/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

#import "Echo.h"

@implementation Echo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.prefix = @"";
    }
    return self;
}
- (instancetype)initWithPrefix:(NSString*)prefix
{
    self = [super init];
    if (self) {
        self.prefix = prefix;
    }
    return self;
}
- (void)echo:(NSString *)message callback:(XWVScriptObject*)callback {
    [callback callWithArguments:@[[NSString stringWithFormat:@"%@%@",self.prefix,message]]
              completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                  NSLog(@"sample.echo : %@",response);
              }];
}


+(NSString *)scriptNameFor:(SEL)selector {
    return selector == @selector(initWithPrefix:) ? @"" : nil;
}
@end

