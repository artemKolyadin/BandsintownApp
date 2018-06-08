//
//  AKAnnotation.h
//  MapKitTest
//
//  Created by Artem Kolyadin on 13.03.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
@interface AKAnnotation : NSObject <MKAnnotation>

@property (nonatomic,  copy, nullable) NSString *title;
@property (nonatomic,   copy, nullable) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
