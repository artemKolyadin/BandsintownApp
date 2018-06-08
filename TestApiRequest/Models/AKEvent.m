//
//  AKEvent.m
//  TestApiRequest
//
//  Created by Artem Kolyadin on 18.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//


#import "AKEvent.h"
#import "AKArtist.h"
#import "AKVenue.h"


static const NSString *kEventArtistIdKey = @"artist_id";
static const NSString *kEventDateKey = @"datetime";
static const NSString *kEventIDKey = @"id";
static const NSString *kEventTicketStatusKey = @"status";
static const NSString *kEventURLKey = @"url";
static const NSString *kEventVenueKey = @"venue";


@implementation AKEvent


- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        _eventID = [dictionary objectForKey:kEventIDKey];
        _ticketStatus = [self sanitizedString:[dictionary objectForKey:kEventTicketStatusKey]];
        _eventDate = [self dateFromDateString:[self sanitizedString:[dictionary objectForKey:kEventDateKey]]];
        _eventURL = [NSURL URLWithString:[self sanitizedString:[dictionary objectForKey:kEventURLKey]]];
        _eventArtistID = [self sanitizedString:[dictionary objectForKey:kEventArtistIdKey]];
        NSDictionary *venueDictionary = [dictionary objectForKey:kEventVenueKey];
        _venue = [[AKVenue alloc] initWithDictionary:venueDictionary];
    }
    
    return self;
}

// Checks that a string from the response object is not an instance of NSNull
- (NSString *)sanitizedString:(NSString *)string
{
    if ((id)string == [NSNull null]) {
        return nil;
    } else {
        return string;
    }
}

// Converts formatted strings from the JSON into NSDate
- (NSDate *)dateFromDateString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    return [dateFormatter dateFromString:dateString];
}

// Converts NSDate into NSString for output eventDate in tableView

+(NSString*) stringFromDate:(NSDate*) date {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc]
                        initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    [formatter setDateFormat:@"MMM d, yyyy"];
    return [formatter stringFromDate:date];
}

@end
