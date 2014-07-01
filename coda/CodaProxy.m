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

- (SystemEventsProcess *)bridge
{
    if (_bridge) {
        return _bridge;
    }

    _bridge = [[[SBApplication applicationWithBundleIdentifier:@"com.apple.systemevents"] applicationProcesses] objectWithName:@"Coda 2"];

    return _bridge;
}

#pragma mark - Private methods

- (void)newWindow
{
    [[[[[[[self.bridge menuBars] lastObject] menus] objectWithName:@"File"] menuItems] objectWithName:@"New Window"] clickAt:nil];
    [[[[[[[self.bridge menuBars] lastObject] menus] objectWithName:@"View"] menuItems] objectWithName:@"Editor"] clickAt:nil];
    [[[[[[[self.bridge menuBars] lastObject] menus] objectWithName:@"View"] menuItems] objectWithName:@"Hide Sidebar"] clickAt:nil];
}

@end
