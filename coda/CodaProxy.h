//
//  CodaProxy.h
//  coda
//
//  Created by Christoffer Winterkvist on 6/30/14.
//  Copyright (c) 2014 zenangst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ScriptingBridge/SBApplication.h>
#import "Coda2.h"
#import "SystemEvents.h"

@interface CodaProxy : NSObject

@property (nonatomic, retain) SystemEventsProcess *bridge;
@property (nonatomic, retain) NSDictionary *options;
@property (nonatomic, retain) NSDictionary *availableOptions;

- (void)openFile:(NSString *)path;

@end
