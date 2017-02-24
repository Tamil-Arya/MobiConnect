//
//  UserModel.h
//  CuB
//
//  Created by vishwavijet on 2/24/17.
//  Copyright © 2017 Tamil Selvan R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserLocationModel.h"
@interface UserModel : NSObject


@property(nonatomic, strong)NSString *EmailId;
@property(nonatomic, strong)NSString *FirstName;
@property(nonatomic, strong)NSString *Latitude;
@property(nonatomic, strong)NSString *Longitude;
@property(nonatomic, strong)NSString *UserId;
@property(nonatomic, strong)UserLocationModel *locationModel;

-(id)initWithDictionary:(NSDictionary *)dict;
@end
