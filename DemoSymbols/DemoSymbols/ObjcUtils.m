//
//  ObjcUtils.m
//  DemoSymbols
//
//  Created by Omar Zuñiga on 21/12/23.
//

#import "ObjcUtils.h"
#include <sys/sysctl.h>
#include <UIKit/UIKit.h>

@implementation ObjcUtils

- (NSTimeInterval)uptime {
    return [NSProcessInfo processInfo].systemUptime;
}

- (NSArray<UITextInputMode *>*)activeModes {
    return [UITextInputMode activeInputModes];
}

@end
