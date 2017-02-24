//
//  UserLocationModel.h
//  CuB
//
//  Created by vishwavijet on 2/24/17.
//  Copyright © 2017 Tamil Selvan R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface UserLocationModel : NSObject<MKAnnotation>

@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
@property(nonatomic)CLLocationDistance radius;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *subtitle;
@property(nonatomic, copy)NSString *userId;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location withRadius:(double)radius;
@end
