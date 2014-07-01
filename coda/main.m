//
//  main.m
//  coda
//
//  Created by Christoffer Winterkvist on 6/30/14.
//  Copyright (c) 2014 zenangst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZENArgumentsHandler.h"
#import "CodaProxy.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSArray *arguments = [[[NSProcessInfo processInfo] arguments] subarrayWithRange:NSMakeRange(1,(NSUInteger)argc-1)];
        NSDictionary *environment = [[NSProcessInfo processInfo] environment];

        CodaProxy *coda = [[CodaProxy alloc] init];
        ZENArgumentsHandler *argumentsHandler = [[ZENArgumentsHandler alloc] init];

        argumentsHandler.currentWorkingDirectory = environment[@"PWD"];
        NSDictionary *processedArguments = [argumentsHandler process:arguments];
        coda.options = processedArguments[@"options"];

        for (NSString *path in processedArguments[@"paths"]) {
            [coda open:path];
        }
    }
    return 0;
}

