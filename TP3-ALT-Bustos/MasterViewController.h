//
//  jbsMasterViewController.h
//  TP3-ALT-Bustos
//
//  Created by Jordan Bustos on 26/05/2014.
//  Copyright (c) 2014 Jordan Bustos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ville.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;



-(void) finishWithVilles:(NSMutableArray*) villes;

@end
