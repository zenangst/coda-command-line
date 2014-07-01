//
//  CodaProxy.m
//  coda
//
//  Created by Christoffer Winterkvist on 6/30/14.
//  Copyright (c) 2014 zenangst. All rights reserved.
//

#import "CodaProxy.h"
#import <AppKit/AppKit.h>

@implementation CodaProxy

- (void)openFile:(NSString *)path
{
    if (self.options) {
        [[NSWorkspace sharedWorkspace] openFile:path withApplication:@"Coda 2"];
    }
}

@end
