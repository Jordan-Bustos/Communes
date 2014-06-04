//
//  jbsDetailViewController.h
//  TP3-ALT-Bustos
//
//  Created by Jordan Bustos on 26/05/2014.
//  Copyright (c) 2014 Jordan Bustos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Ville.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) Ville * detailItem;

@property (weak, nonatomic) IBOutlet UILabel *lbMAJ;
@property (weak, nonatomic) IBOutlet UILabel *lbCodePostal;
@property (weak, nonatomic) IBOutlet UILabel *lbCodeINSEE;
@property (weak, nonatomic) IBOutlet UILabel *lbCodeRegion;
@property (weak, nonatomic) IBOutlet UILabel *lbLatitude;
@property (weak, nonatomic) IBOutlet UILabel *lbLongitude;
@property (weak, nonatomic) IBOutlet UILabel *lbEloignement;

@property (strong, nonatomic) IBOutlet MKMapView *mkMapView;

@end
