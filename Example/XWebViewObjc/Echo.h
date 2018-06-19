//
//  Echo.h
//  XWebViewObjc_Example
//
//  Created by Futao on 2018/6/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XWebViewObjc/XWebViewObjc-Swift.h>
@interface Echo : NSObject
@property (nonatomic,strong) NSString* prefix;
@end


@interface Echo () <XWVScripting>
- (instancetype)initWithPrefix:(NSString*)prefix;
- (instancetype)init;
@end
