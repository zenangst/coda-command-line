//
//  CodaProxy.m
//  coda
//
//  Created by Christoffer Winterkvist on 6/30/14.
//  Copyright (c) 2014 zenangst. All rights reserved.
//

#import "CodaProxy.h"
#import <AppKit/AppKit.h>
#import <objc/runtime.h>

@implementation CodaProxy

@synthesize options = _options;

- (void)setOptions:(NSDictionary *)options
{
    _options = options;

    SEL selector;
    for (NSString *option in options) {
        selector = NSSelectorFromString(self.availableOptions[option]);
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector];
        }
    }

}

- (void)openFile:(NSString *)path
{
    [[NSWorkspace sharedWorkspace] openFile:path withApplication:@"Coda 2"];
}

#pragma mark - Lazy loading

- (NSDictionary *)availableOptions
{

    if (_availableOptions) {
        return _availableOptions;
    }

    _availableOptions = @{
        @"--new-window" : @"newWindow",
        @"-nw"          : @"newWindow"
    };

    return _availableOptions;
}

#pragma mark - Private methods

- (void)newWindow
{

}

@end
