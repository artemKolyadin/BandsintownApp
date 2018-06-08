//
//  Subscription.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 27.05.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface Subscription : RLMObject
@property (strong,nonatomic) NSString* artist;
@end
