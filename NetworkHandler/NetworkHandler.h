//
//  NetworkHandler.h
//  CuB
//
//  Created by Vishwavijet on 23/02/17.
//  Copyright © 2017 Tamil Selvan R. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NetworkHandler : NSObject
+(NetworkHandler *)sharedInstance;

@property(nonatomic,strong)NSString *loginUserID;
@property(nonatomic,strong)NSString *deviceToken;
@property(nonatomic,strong)CLLocation *userLocation;

-(void)loginUserwithDetails:(NSDictionary *)loginDict withURL:(NSString *)url withMethod:(NSString *)method completionHandler:(void(^)(NSDictionary *response, NSError *error))completionHandler;

-(void)registerDeviceTokenWithDetails:(NSDictionary *)details withURL:(NSString *)url withMethod:(NSString *)method completionHandler:(void(^)(NSDictionary *response, NSError *error))completion;

-(void)saveLocationDetails:(NSDictionary *)locDetails withURL:(NSString *)url withMethod:(NSString *)method completionHandler:(void(^)(NSDictionary *response, NSError *error))completion;

-(void)startRideWithDetails:(NSDictionary *)riderDetails withURL:(NSString *)url withMethod:(NSString *)method completionHandler:(void(^)(NSDictionary *response, NSError *error))completion;

-(void)endRideWithDetails:(NSDictionary *)riderDetails withURL:(NSString *)url withMethod:(NSString *)method completionHandler:(void(^)(NSDictionary *response, NSError *error))completion;

-(void)getUserDetailsWithURL:(NSString *)url withMethod:(NSString *)method completionHandler:(void(^)(NSDictionary *response, NSError *error))completion;

-(void)getUserLocations:(NSString *)url withMethod:(NSString *)method completionHandler:(void(^)(NSArray *response, NSError *error))completion;

-(void)sendRideRequest:(NSDictionary *)riderDetails withURL:(NSString *)url withMethod:(NSString *)method completionHandler:(void(^)(NSDictionary *response, NSError *error))completion;
@end
