//
//  AKArtist.m
//  TestApiRequest
//
//  Created by Artem Kolyadin on 18.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import "AKArtist.h"

static const NSString *kArtistIDKey = @"id";
static const NSString *kArtistNameKey = @"name";
static const NSString *kArtistImageURLKey = @"image_url";
static const NSString *kArtistThumbURLKey = @"thumb_url";
static const NSString *kFacebookTourDatesURLKey = @"facebook_tour_dates_url";
static const NSString *kUpcomingEventsCountKey = @"upcoming_event_count";

static EventsTableViewController *_vc = nil;

@implementation AKArtist


+ (EventsTableViewController*) vc {
    if (_vc == nil) {
        _vc = [[EventsTableViewController alloc] init];
    }
    return _vc;
}

+ (void)setVc:(EventsTableViewController *)vc{
    _vc=vc;
}


//prepare simple artist name for correct API-request
//Delete begin-end string whitespaces, replace whitespaces beetween words by "%20" 
+ (NSString*) prepareArtistName:(NSString*) string {
    NSString* artistName;
    artistName = [string stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    artistName = [artistName stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    artistName=[artistName capitalizedString];
    return artistName;
}

#pragma mark -
#pragma mark - Public Initializers

- (id)initWithDictionary:(NSDictionary *)dictonary
{
    if (self = [super init]) {
        _name = [dictonary objectForKey:kArtistNameKey];
        _artistID = [dictonary objectForKey:kArtistIDKey];
        _imageURL = [NSURL URLWithString:[dictonary objectForKey:kArtistImageURLKey]];
        _thumbURL = [NSURL URLWithString:[dictonary objectForKey:kArtistThumbURLKey]];
        _facebookTourDatesURL = [NSURL URLWithString:[dictonary objectForKey:kFacebookTourDatesURLKey]];
        _numberOfUpcomingEvents = [dictonary objectForKey:kUpcomingEventsCountKey];
        [self requestImageWithURL:_thumbURL andCompletionHandler:^(BOOL success, UIImage *artistImage, NSError *error) {
            if (success) {
                _thumbImage=artistImage;
                [_vc.tableView reloadData];
            }
        }];
        [self requestImageWithURL:_imageURL andCompletionHandler:^(BOOL success, UIImage *artistImage, NSError *error) {
            if (success) {
                _bigImage=artistImage;
            }
        }];
    }
    return self;
}

#pragma mark -
#pragma mark - Public methods

-(void) requestImageWithURL:(NSURL *)url andCompletionHandler:(artistImageCompletionHandler)completionHandler
{
    NSURLRequest *artistImageRequest = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:artistImageRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               if (!connectionError) {
                                   UIImage *artistImage = [UIImage imageWithData:data];
                                   completionHandler(YES, artistImage, nil);
                               } else {
                                   completionHandler(NO, nil, connectionError);
                               }
                           }];
}
@end
