//
//  RealmManager.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 22.05.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm.h"
#import "UserAcc.h"

@interface RealmManager : NSObject

+(UserAcc*) getUserFromRealm: (int) userId;
+(void) updateUserInfo:(UserAcc*) user;
+(void) createNewUser : (int) userId;

@end
