//
//  UserModel.m
//  CuB
//
//  Created by vishwavijet on 2/24/17.
//  Copyright © 2017 Tamil Selvan R. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
@synthesize EmailId,FirstName,Latitude,Longitude,UserId;

-(id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.EmailId = dict[@"EmailId"];
        self.FirstName = dict[@"FirstName"];
        self.Latitude = dict[@"Latitude"];
        self.Longitude = dict[@"Longitude"];
        self.UserId = dict[@"UserId"];
        self.locationModel = [[UserLocationModel alloc] initWithCoordinates:CLLocationCoordinate2DMake([self.Latitude doubleValue], [self.Longitude doubleValue]) withRadius:20];
        self.locationModel.title = self.FirstName;
        self.locationModel.subtitle = self.EmailId;
        self.locationModel.userId = self.UserId;
    }
    return self;
}
@end
