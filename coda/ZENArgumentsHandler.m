//
//  ZENArgumentsHandler.m
//  coda
//
//  Created by Christoffer Winterkvist on 6/30/14.
//  Copyright (c) 2014 zenangst. All rights reserved.
//

#import "ZENArgumentsHandler.h"

@implementation ZENArgumentsHandler

NSString * const ZENAbsolutePathDelimiter = @"/";
NSString * const ZENOptionDelimiter = @"--";

- (NSDictionary *)process:(NSArray *)arguments
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *paths   = [NSMutableArray array];
    NSMutableArray *options = [NSMutableArray array];

    for (NSString *argument in arguments) {
        if ([self isAbsolutePath:argument]) {
            [paths addObject:argument];
            continue;
        }

        if ([self isOption:argument]) {
            [options addObject:argument];
            continue;
        }

        [paths addObject:[NSString stringWithFormat:@"%@/%@", self.currentWorkingDirectory, argument]];
    }
    [mutableDictionary setObject:[options copy] forKey:@"options"];
    [mutableDictionary setObject:[paths copy] forKey:@"paths"];

	return [mutableDictionary copy];
}

#pragma mark - Private methods

- (BOOL)isAbsolutePath:(NSString *)path
{
    return ([path rangeOfString:ZENAbsolutePathDelimiter].location != NSNotFound) ? YES : NO;
}

- (BOOL)isOption:(NSString *)path
{
    return ([path hasPrefix:ZENOptionDelimiter]) ? YES : NO;
}

@end
