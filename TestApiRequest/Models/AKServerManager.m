//
//  AKServerManager.m
//  TestApiRequest
//
//  Created by Artem Kolyadin on 17.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//


#import "AFNetworking.h"
#import "AKServerManager.h"
#import "AKArtist.h"

@interface AKServerManager()
@property (strong,nonatomic) AFHTTPSessionManager* sessionManager;
@end
@implementation AKServerManager

+(AKServerManager*) sharedManager {
    static AKServerManager* manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[AKServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString:@"https://rest.bandsintown.com/artists/"];
        self.sessionManager=[[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

-(void) getEventsForArtist:(NSString *) artistName
                 onSuccess:(void(^)(NSArray* events)) success
                 onFailure:(void(^)(NSError* error))  failure  {
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:@"MyTestApp", @"app_id", nil];
    NSString* get = [artistName stringByAppendingString:@"/events"];
    [self.sessionManager GET:get parameters:params progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             if (success) {
                 success(responseObject);
             }
    }
         failure:^(NSURLSessionTask *operation, NSError *error) {
             if (failure) {
                failure(error);
             }
    }];
}

-(void) getArtist:(NSString*) artistName
        onSuccess:(void(^)(AKArtist* artist)) success
        onFailure:(void(^)(NSError* error))  failure  {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:@"MyTestApp", @"app_id", nil];
    [self.sessionManager GET:artistName parameters:params progress:nil
                     success:^(NSURLSessionTask *task, id responseObject) {
                         if (success) {
                             AKArtist* artist = [[AKArtist alloc] initWithDictionary:responseObject];
                             success(artist);
                         }
                     }
                     failure:^(NSURLSessionTask *operation, NSError *error) {
                         
                         if (failure) {
                             failure(error);
                         }
                     }];
}

@end
