//
//  AKArtist.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 18.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>
#import "EventsTableViewController.h"
typedef void (^artistImageCompletionHandler)(BOOL success,
                                             UIImage *artistImage,
                                             NSError *error);

@interface AKArtist : NSObject


@property (strong, nonatomic) NSString* artistID;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *thumbURL;
@property (strong, nonatomic) NSURL *facebookTourDatesURL;
@property (strong, nonatomic) NSNumber *numberOfUpcomingEvents;
@property (strong, nonatomic) UIImage* thumbImage;
@property (strong, nonatomic) UIImage* bigImage;
// For reload data in tableViewController when image will be downloaded
@property (class, strong, nonatomic) EventsTableViewController* vc;

+ (NSString*) prepareArtistName:(NSString*) string;
- (id)initWithDictionary:(NSDictionary *)dictonary;
- (void)requestImageWithURL:(NSURL*) url andCompletionHandler:(artistImageCompletionHandler)completionHandler;

@end
