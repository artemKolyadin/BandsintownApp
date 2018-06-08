//
//  User.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 22.05.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Subscription.h"

RLM_ARRAY_TYPE(Subscription)
@interface UserAcc : RLMObject
@property int userId;
@property RLMArray<Subscription *><Subscription> *subscriptions;
@end
