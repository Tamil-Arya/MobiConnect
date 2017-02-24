//
//  UserLocationModel.m
//  CuB
//
//  Created by vishwavijet on 2/24/17.
//  Copyright © 2017 Tamil Selvan R. All rights reserved.
//

#import "UserLocationModel.h"

@implementation UserLocationModel
- (id)initWithCoordinates:(CLLocationCoordinate2D)location withRadius:(double)radius{
    if (self = [super init]) {
        self.coordinate = location;
        self.radius = radius;
    }
    return self;
}
@end
