//
//  jbsConnectionDelegate.h
//  TP3-ALT-Bustos
//
//  Created by Jordan Bustos on 26/05/2014.
//  Copyright (c) 2014 Jordan Bustos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Commune.h"
#import "MasterViewController.h"

@interface DownloaderDelegate : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


@property (strong) NSMutableData * receivedData;
@property (strong) NSString * URLString;
@property (strong) NSString * dateOfDay;
@property (strong) NSString * nsPathOfTmpFile;
@property (strong) NSString * nsPathOfDocumentFile;

@property (strong) NSMutableArray * communes;

@property (strong) MasterViewController * delegate;
-(id)initWithURLString:(NSString *)URLString andDelegate:(MasterViewController *) delegate;
-(BOOL) start;

@end