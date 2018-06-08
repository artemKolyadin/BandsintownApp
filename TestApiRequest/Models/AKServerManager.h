//
//  AKServerManager.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 17.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AKArtist;
@interface AKServerManager : NSObject
+(AKServerManager*) sharedManager;

-(void) getArtist:(NSString*) artistName
        onSuccess:(void(^)(AKArtist* artist)) success
        onFailure:(void(^)(NSError* error))  failure;

-(void) getEventsForArtist: (NSString*) artistName
                 onSuccess:(void(^)(NSArray* events)) success
                 onFailure:(void(^)(NSError* error))  failure;
@end
