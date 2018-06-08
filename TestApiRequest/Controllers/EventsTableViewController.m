//
//  EventsTableViewController.m
//  TestApiRequest
//
//  Created by Artem Kolyadin on 17.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import "AFNetworking.h"
#import "EventsTableViewController.h"
#import "AddSubscriptionViewController.h"
#import "DetailViewController.h"
#import "AKModels.h"
#import "AKEventCell.h"
#import "RealmManager.h"


@interface EventsTableViewController ()
@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longtitude;
@end

@implementation EventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.rightBarButtonItems=@[addButton];
    
    self.eventsArray=[NSMutableArray array];
    self.artistsArray=[NSMutableArray array];
    self.namesArray=[NSMutableArray array];
    [AKArtist setVc:self];
    
    [self runLocationManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Getting events and artists

-(void) getEventsForSubscribe {
    [self loadSubscriptions];
    for (NSString* name in self.namesArray){
        [self getEventsForArtist:name];
    }
}

- (void) loadSubscriptions {
    UserAcc* currentUserInfo = [RealmManager getUserFromRealm:1];
    for (Subscription* sub in currentUserInfo.subscriptions) {
        [self.namesArray addObject:sub.artist];
    }
}

-(void) getEventsForArtist: (NSString*) name {
    AKServerManager* manager =[AKServerManager sharedManager];
    [manager getEventsForArtist:name
    onSuccess:^(NSArray *events) {
        for (NSDictionary* dictionary in events){
            AKEvent* event = [[AKEvent alloc] initWithDictionary:dictionary];
            if ([self filterByRadius:event]){
            [self.eventsArray addObject:event];
            [self sortEventsArray];
            [self groupEventsByMonth];
            [self.tableView reloadData];
            }
        }
    }
    onFailure:^(NSError *error) {
        NSLog(@"Error = %@",[error localizedDescription]);
    }];
    
    [manager getArtist:name
    onSuccess:^(AKArtist *artist) {
        [self.artistsArray addObject:artist];
    } onFailure:^(NSError *error) {
        NSLog(@"Error = %@",[error localizedDescription]);
    }];
}

-(AKArtist*) getArtistForEvent: (AKEvent*) event {
    for (AKArtist* artist in self.artistsArray){
        if ([artist.artistID isEqualToString:event.eventArtistID])
        {
            return artist;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark - Sort and group events by date

-(void) sortEventsArray {
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"eventDate"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    self.eventsArray = [NSMutableArray arrayWithArray:[self.eventsArray
                                 sortedArrayUsingDescriptors:sortDescriptors]];
}

- (NSString*) createKey:(NSDate *)inputDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:inputDate];
    NSString* month = [NSString stringWithFormat:@"%ld",dateComps.month];
    NSString* year = [NSString stringWithFormat:@"%ld",dateComps.year];
    NSString* key = [month stringByAppendingString:year];
    return key;
}

-(void) groupEventsByMonth {
    self.eventsGroupedByDate = [NSMutableDictionary dictionary];
    for (AKEvent *event in self.eventsArray)
    {
        NSString *keyRepresentingThisYearAndMonth = [self createKey:event.eventDate];
        NSMutableArray *eventsForThisMonth = [self.eventsGroupedByDate objectForKey:keyRepresentingThisYearAndMonth];
        if (eventsForThisMonth == nil) {
            eventsForThisMonth = [NSMutableArray array];
            [self.eventsGroupedByDate setObject:eventsForThisMonth forKey:keyRepresentingThisYearAndMonth];
        }
        [eventsForThisMonth addObject:event];
    }
    
    NSSortDescriptor *sortDescriptorLength;
    sortDescriptorLength = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                  ascending:YES];
    NSSortDescriptor *sortDescriptorSelf;
    sortDescriptorSelf = [[NSSortDescriptor alloc] initWithKey:@"self"
                                                       ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:
                                sortDescriptorLength,sortDescriptorSelf,nil];
    
    self.sortedSectionsKeys=[self.eventsGroupedByDate.allKeys
                             sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.eventsGroupedByDate.allKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString* key = [self.sortedSectionsKeys objectAtIndex:section];
    NSArray* events = [self.eventsGroupedByDate valueForKey:key];
    return [events count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* key = [self.sortedSectionsKeys objectAtIndex:section];
    NSArray* events = [self.eventsGroupedByDate valueForKey:key];
    AKEvent* event = [events objectAtIndex:0];
    NSDate* date =  event.eventDate;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    NSString *sectionName= [formatter stringFromDate:date];
    return sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier=@"Cell";
    AKEventCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[AKEventCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSString* key = [self.sortedSectionsKeys objectAtIndex:indexPath.section];
    NSArray* events=[self.eventsGroupedByDate objectForKey:key];
    AKEvent* event = [events objectAtIndex:indexPath.row];
    AKArtist* artist = [self getArtistForEvent:event];
    cell.artistImage.image=artist.thumbImage;
    cell.artistNameLabel.text=artist.name;
    cell.eventDateLabel.text=[AKEvent stringFromDate:event.eventDate];
    cell.eventCityLabel.text=event.venue.city;
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
         DetailViewController* vc= [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewControllerID"];
         NSString* key = [self.sortedSectionsKeys objectAtIndex:indexPath.section];
         NSArray* events=[self.eventsGroupedByDate objectForKey:key];
         AKEvent* event = [events objectAtIndex:indexPath.row];
         AKArtist* artist = [self getArtistForEvent:event];
         vc.artist=artist;
         vc.event=event;
         [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -Actions

-(void) actionAdd:(UIButton*) sender {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    AddSubscriptionViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AddSubscription"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)locationButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"toGPSControllerSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toGPSControllerSegue"]) {
        self.navigationItem.backBarButtonItem.title = @"Cancel";
    }
}

- (void) runLocationManager {
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    } else {
        NSLog(@"Location services are not enabled");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    CLLocation *location = [locations lastObject];
    self.latitude = location.coordinate.latitude;
    self.longtitude = location.coordinate.longitude;
    [self getEventsForSubscribe];
}

- (BOOL) filterByRadius: (AKEvent*) event {
        NSInteger radius= [[NSUserDefaults standardUserDefaults] integerForKey:@"radius"];
        CLLocation* userLocation = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longtitude];
        CLLocation* eventLocation = [[CLLocation alloc] initWithLatitude:event.venue.coordinate.latitude longitude:event.venue.coordinate.longitude];
        CLLocationDistance distance = [userLocation distanceFromLocation:eventLocation];
        if (radius == 0) return true;
        if (distance > radius*1000) {
            return false;
        }
        return true;
    }


@end
