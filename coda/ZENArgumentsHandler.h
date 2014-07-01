//
//  ZENArgumentsHandler.h
//  coda
//
//  Created by Christoffer Winterkvist on 6/30/14.
//  Copyright (c) 2014 zenangst. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZENArgumentsHandler : NSObject

@property (nonatomic, retain) NSString *currentWorkingDirectory;

- (NSDictionary *)process:(NSArray *)arguments;

@end
