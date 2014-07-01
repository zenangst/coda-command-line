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

- (void)open:(NSString *)path
{
    if (self.sites) {
        NSString *filePath = [[[path stringByDeletingLastPathComponent] stringByExpandingTildeInPath] stringByResolvingSymlinksInPath];
        NSString *selectedSite;
        for (NSString *site in self.sites) {
            if ([filePath hasPrefix:site]) {
                selectedSite = [NSString stringWithFormat:@"%@/%@", [self sitesDirectory],self.sites[site]];
                [self openWithCoda:selectedSite];
                continue;
            }
        }
    }
    [self openWithCoda:path];
}

#pragma mark - Lazy loading

- (NSDictionary *)availableOptions
{

    if (_availableOptions) {
        return _availableOptions;
    }

    _availableOptions = @{
        @"--new-window"       : @"newWindow",
        @"-nw"                : @"newWindow",
        @"--respect-projects" : @"respectProjects",
        @"-rp"                : @"respectProjects"
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

- (void)openWithCoda:(NSString *)path
{
    [[NSWorkspace sharedWorkspace] openFile:path withApplication:@"Coda 2"];
}

- (NSString *)applicationSupportDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths firstObject];
    return applicationSupportDirectory;
}

- (NSString *)sitesDirectory
{
    NSString *sitesDirectory = [NSString stringWithFormat:@"%@/Coda 2/Sites", [self applicationSupportDirectory]];
    return sitesDirectory;
}

- (void)newWindow
{
    [[[[[[[self.bridge menuBars] lastObject] menus] objectWithName:@"File"] menuItems] objectWithName:@"New Window"] clickAt:nil];
    [[[[[[[self.bridge menuBars] lastObject] menus] objectWithName:@"View"] menuItems] objectWithName:@"Editor"] clickAt:nil];
}

- (void)respectProjects
{
    NSArray *sites = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self sitesDirectory] error:nil];

    NSMutableDictionary *sitesDictionary = [NSMutableDictionary dictionary];
    for (NSString *sitePath in sites) {
        if ([sitePath hasSuffix:@"codasite"]) {
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@", [self sitesDirectory], sitePath];
            NSString *configuredSitePath = [self extractPathFromSite:fullPath];
            [sitesDictionary setObject:sitePath forKey:configuredSitePath];
        }
    }
    self.sites = [sitesDictionary copy];
}

- (NSString *)extractPathFromSite:(NSString *)path
{
    NSString *fullPath = [NSString stringWithFormat:@"%@/site.plist", path];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:NO]) {
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:fullPath];
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSDictionary *siteDictionary = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
        for (id object in siteDictionary[@"$objects"]) {
            if ([object isKindOfClass:[NSString class]]) {
                if ([object hasPrefix:@"/Volumes"]) {
                    NSRange searchRange = [object rangeOfString:@"/Users"];
                    return [object substringFromIndex:searchRange.location];
                }
            }
        }
    }
    return @"";
}

@end
