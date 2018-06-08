//
//  AddSubscriptionViewController.m
//  TestApiRequest
//
//  Created by Artem Kolyadin on 18.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import "AddSubscriptionViewController.h"
#import "AKServerManager.h"
#import "AKEvent.h"
#import "AKArtist.h"
#import "RealmManager.h"
static const NSString *kArtistListKey = @"artistList";

typedef enum {
    ASVButtonStateNormal,
    ASVButtonStateExists,
    ASVButtonStateNotFound,
    ASVButtonStateSuccess
} ASVButtonState;

@interface AddSubscriptionViewController ()
@end

@implementation AddSubscriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark -Actions

-(IBAction)actionAddSubscribtion:(id)sender {
    [self.view endEditing:YES];
    NSString* artistName = self.artistNameTextField.text;
    
    artistName=[AKArtist prepareArtistName:artistName];
    
    AKServerManager* manager =[AKServerManager sharedManager];
    [manager getArtist:artistName
             onSuccess:^(AKArtist *artist) {
                 NSMutableArray* subscriptionsArray = [NSMutableArray array];
                 UserAcc* currentUserInfo = [[UserAcc alloc] init];
                 if ([RealmManager getUserFromRealm:1]==nil) {
                    [RealmManager createNewUser:1];
                 }
                 currentUserInfo = [RealmManager getUserFromRealm:1];
                 for (Subscription* sub in currentUserInfo.subscriptions) {
                     [subscriptionsArray addObject:sub.artist];
                 }
                 if (![subscriptionsArray containsObject:artistName]) {
                     [subscriptionsArray addObject:artistName];
                     Subscription* newSubscription = [[Subscription alloc] init];
                     newSubscription.artist = artistName;
                     [[RLMRealm defaultRealm] beginWriteTransaction];
                     [currentUserInfo.subscriptions addObject:newSubscription];
                     [[RLMRealm defaultRealm] commitWriteTransaction];
                     [RealmManager updateUserInfo:currentUserInfo];
                     [self setButtonStyle:ASVButtonStateSuccess];
                 }
                 else {
                     [self setButtonStyle:ASVButtonStateExists];
                 }
                 self.artistNameLabel.text=artist.name;
                 [artist requestImageWithURL:artist.imageURL andCompletionHandler:^(BOOL success, UIImage *artistImage, NSError *error) {
                     if (success) self.addedArtistImageView.image=artistImage;
                 }];
                 NSString* baseString = [NSString stringWithFormat:@"Upcomming events: %ld",artist.numberOfUpcomingEvents.integerValue];
                 self.countEventsLabel.text=baseString;
                 
             } onFailure:^(NSError *error) {
                 [self setButtonStyle:ASVButtonStateNotFound];
                 NSLog(@"Error = %@",[error localizedDescription]);
             }];
}


- (IBAction)actionArtistNameTextFieldDidBeginEditing:(id)sender {
    [self.artistNameTextField setKeyboardType: UIKeyboardTypeASCIICapable];
    [self setButtonStyle:ASVButtonStateNormal];
    self.artistNameLabel.text=@"";
    self.countEventsLabel.text=@"";
}

-(void) setButtonStyle:(ASVButtonState) state {
    switch (state) {
        case ASVButtonStateExists:
            self.addButton.backgroundColor=[UIColor colorWithRed:2.0f/255.0f green:126.0f/255.0f blue:162.0f/255.0f alpha:1];
            [self.addButton setTitle:@"Artist already exists" forState:UIControlStateNormal];
            break;
        case ASVButtonStateNotFound:
            self.addButton.backgroundColor=[UIColor colorWithRed:2.0f/255.0f green:126.0f/255.0f blue:162.0f/255.0f alpha:1];
            [self.addButton setTitle:@"Artist not found" forState:UIControlStateNormal];
            break;
        case ASVButtonStateSuccess:
            self.addButton.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:112.0f/255.0f blue:218.0f/255.0f alpha:1];
            [self.addButton setTitle:@"Artist successfully added" forState: UIControlStateNormal];
            break;
        default:
            self.addButton.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:112.0f/255.0f blue:218.0f/255.0f alpha:1];
            [self.addButton setTitle:@"Add" forState: UIControlStateNormal];
            break;
    }
}

@end
