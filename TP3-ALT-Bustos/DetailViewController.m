//
//  jbsDetailViewController.m
//  TP3-ALT-Bustos
//
//  Created by Jordan Bustos on 26/05/2014.
//  Copyright (c) 2014 Jordan Bustos. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem)
    {
        _lbMAJ.text  = [NSString stringWithFormat:@"Maj : %@", _detailItem.maj];
        _lbCodePostal.text  = [NSString stringWithFormat:@"Code postal : %@", _detailItem.codePostal];
        _lbCodeINSEE.text  = [NSString stringWithFormat:@"Code INSEE : %@", _detailItem.codeINSEE];
        _lbCodeRegion.text  = [NSString stringWithFormat:@"Code région : %@", _detailItem.codeRegion];
        _lbLatitude.text  = [NSString stringWithFormat:@"Latitude : %f", _detailItem.latitude];
        _lbLongitude.text  = [NSString stringWithFormat:@"Longitude : %f", _detailItem.longitude];
        _lbEloignement.text  = [NSString stringWithFormat:@"Éloignement : %f", _detailItem.eloignement];
        [self configureMKMapView];
        
    }
}

-(void) configureMKMapView
{
    //_mkMapView=[[MKMapView alloc] init];
    
    _mkMapView.showsUserLocation=TRUE;
    _mkMapView.mapType=MKMapTypeHybrid;
    
    //definir le zoom
    MKCoordinateSpan span;
    span.latitudeDelta=0.5;
    span.longitudeDelta=0.5;
    
    //definir les coordonees
    CLLocationCoordinate2D coordonnes;
    coordonnes.latitude= _detailItem.latitude;
    coordonnes.longitude=_detailItem.longitude;
    
    // affiliation des coordonnees a la region
    MKCoordinateRegion region;
    region.span=span;
    region.center=coordonnes;
    
    // centrer la carte
    [_mkMapView setRegion:region animated:TRUE];
    
    // ajout d'un repere sur la carte
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = coordonnes;
    annotationPoint.title = _detailItem.nom;
    annotationPoint.subtitle = _detailItem.codePostal;
    [_mkMapView addAnnotation:annotationPoint];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
