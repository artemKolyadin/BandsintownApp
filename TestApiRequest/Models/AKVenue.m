//
//  AKVenue.m
//  TestApiRequest
//
//  Created by Artem Kolyadin on 18.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import "AKVenue.h"

static const NSString *kVenueCityKey = @"city";
static const NSString *kVenueCountryKey = @"country";
static const NSString *kVenueLatitudeKey = @"latitude";
static const NSString *kVenueLongitudeKey = @"longitude";
static const NSString *kVenueNameKey = @"name";
static const NSString *kVenueRegionKey = @"region";

@implementation AKVenue
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _name = [dictionary objectForKey:kVenueNameKey];
        _city = [dictionary objectForKey:kVenueCityKey];
        _region = [dictionary objectForKey:kVenueRegionKey];
        _country = [dictionary objectForKey:kVenueCountryKey];
        double latitude = [[dictionary objectForKey:kVenueLatitudeKey] doubleValue];
        double longtitude = [[dictionary objectForKey:kVenueLongitudeKey] doubleValue];
        _coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
    }
    return self;
}
@end
