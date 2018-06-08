//
//  RealmManager.m
//  TestApiRequest
//
//  Created by Artem Kolyadin on 22.05.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//
//
#import "RealmManager.h"

@implementation RealmManager

+(void) updateUserInfo:(UserAcc*) user
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [UserAcc createOrUpdateInRealm:[RLMRealm defaultRealm] withValue:user];
    [realm commitWriteTransaction];
}

+(UserAcc*) getUserFromRealm: (int)  userId {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userId = %u",
                         userId];
    RLMResults<UserAcc*> *users = [UserAcc objectsWithPredicate:pred];
    if (users.count!=0) {
        return users[0];
    }
    else return nil;
}

+(void) createNewUser : (int) userId {
    UserAcc* user  = [[UserAcc alloc] init];
    user.userId = userId;
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:user];
    [realm commitWriteTransaction];
}

@end
