//
//  EventsTableViewController.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 17.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//  You should run this application on iPhone 5/5s/SE only.
//  UI of some viewcontrollers is non-adaptive for other displays.

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface EventsTableViewController : UITableViewController <CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager *locationManager;

@property (strong,nonatomic) NSMutableArray* eventsArray;
@property (strong,nonatomic) NSMutableArray* filteredArray;
@property (strong,nonatomic) NSMutableArray* artistsArray;
@property (strong,nonatomic) NSMutableArray* namesArray;
@property (strong,nonatomic) NSMutableDictionary* eventsGroupedByDate; 
@property (strong,nonatomic) NSArray* sortedSectionsKeys;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
- (IBAction)locationButtonClicked:(id)sender;

@end
