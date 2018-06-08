//
//  AddSubscriptionViewController.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 18.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSubscriptionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *artistNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIImageView *addedArtistImageView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countEventsLabel;

- (IBAction)actionAddSubscribtion:(id)sender;
- (IBAction)actionArtistNameTextFieldDidBeginEditing:(id)sender;
@end
