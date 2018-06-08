//
//  DetailViewController.m
//  TestApiRequest
//
//  Created by Artem Kolyadin on 19.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import "AKModels.h"
#import "DetailViewController.h"
#import "EventsTableViewController.h"

static const NSString *kArtistListKey = @"artistList";

@interface DetailViewController ()<MKMapViewDelegate>
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Subscriptions" style:UIBarButtonItemStylePlain target:self action:@selector(actionBack:)];
    self.navigationItem.leftBarButtonItem = newBackButton;
    
    [self setPinOnMapView];
    
    self.artistNameLabel.text=self.artist.name;
    
    // Prepare artistName string for insert into request URL
    NSString* artistNameForRequest = [self.artist.name stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    artistNameForRequest = [artistNameForRequest stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    artistNameForRequest=[artistNameForRequest capitalizedString];

    
    [[AKServerManager sharedManager] getArtist:artistNameForRequest onSuccess:^(AKArtist *artist) {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL:artist.imageURL];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.artistImage.image = [UIImage imageWithData: data];
            });
        });
    } onFailure:^(NSError *error) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) setPinOnMapView {
    AKAnnotation* annotation = [[AKAnnotation alloc] init];
    annotation.title=self.event.venue.name;
    annotation.coordinate=self.event.venue.coordinate;
    [self.mapView addAnnotation:annotation];
    CLLocationCoordinate2D coordinate = annotation.coordinate;
    MKMapPoint center = MKMapPointForCoordinate(coordinate);
    static double delta = 2000;
    MKMapRect rect = MKMapRectMake(center.x-delta, center.y-delta, 2*delta, 2*delta);
    [self.mapView setVisibleMapRect:rect
                           animated:YES];
}

#pragma mark -
#pragma mark - Actions


- (IBAction)actionUnsubscribe:(UIButton*)sender {
    NSMutableArray* namesArray = [NSMutableArray arrayWithArray:
                                  [[NSUserDefaults standardUserDefaults] objectForKey:kArtistListKey]];
    NSString* artistName = [AKArtist prepareArtistName:self.artist.name];
    for (int i=0;i<namesArray.count;i++)
        if ([[namesArray objectAtIndex:i] isEqualToString:artistName]){
            [namesArray removeObjectAtIndex:i];
            [[NSUserDefaults standardUserDefaults] setObject:namesArray forKey:kArtistListKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.subscribeButton.backgroundColor=[UIColor colorWithRed:233.0f/255.0f green:117.0f/255.0f blue:105.0f/255.0f alpha:1];
            [self.subscribeButton setTitle:@"Unfollowed" forState: UIControlStateNormal];
        }
    }

-(void) actionBack : (UIBarButtonItem*) sender {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    EventsTableViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"EventsViewControllerID"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -
#pragma mark - MKMapViewDelegate

- (nullable MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    static NSString* identifier = @"Annotation";
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!pin){
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        pin.pinColor=MKPinAnnotationColorPurple;
        pin.animatesDrop=YES;
        pin.canShowCallout=YES;
    } else {
        pin.annotation=annotation;
    }
    return pin;
}

@end
