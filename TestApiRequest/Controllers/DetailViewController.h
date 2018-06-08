//
//  DetailViewController.h
//  TestApiRequest
//
//  Created by Artem Kolyadin on 19.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class  AKEvent;
@class  AKArtist;
@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UIButton *subscribeButton;
@property (strong,nonatomic) AKEvent *event;
@property (strong,nonatomic) AKArtist *artist;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
- (IBAction)actionUnsubscribe:(id)sender;
@end
