//
//  AKEvent.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 18.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AKVenue;
@interface AKEvent : NSObject

@property (strong, nonatomic) NSString* eventArtistID;
@property (strong, nonatomic) NSDate *eventDate;
@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *ticketStatus;
@property (strong, nonatomic) NSURL *eventURL;
@property (strong, nonatomic) AKVenue *venue;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (NSString*) stringFromDate: (NSDate*) date;
@end
