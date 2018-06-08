//
//  AKEventCell.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 19.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventCityLabel;

@end
