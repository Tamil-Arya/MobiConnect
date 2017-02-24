//
//  AppDelegate.m
//  MobiConnect
//
//  Created by Tamil Selvan R on 24/02/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkHandler.h"

@interface AppDelegate ()
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,assign)BOOL isRemoteNotification;
@property(nonatomic,strong)NSString *starterUserId;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    
    //register for notifications
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    UNNotificationAction *yesAction = [UNNotificationAction actionWithIdentifier:@"ACCEPT" title:@"Accept" options:UNNotificationActionOptionForeground];
    UNNotificationAction *noAction = [UNNotificationAction actionWithIdentifier:@"DECLINE" title:@"Reject" options:UNNotificationActionOptionForeground];
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    [category setActions:@[yesAction,noAction] forContext:UIUserNotificationActionContextDefault];
    [category setIdentifier:@"RIDE_SHARE"];
    
    [center setNotificationCategories:[NSSet setWithObject:category]];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Notification methods

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenString = [self stringWithDeviceToken:deviceToken];
    [NetworkHandler sharedInstance].deviceToken = deviceTokenString;
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Device token registration error : %@",error.description);
}

- (NSString *)stringWithDeviceToken:(NSData* )deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    
    return [token copy];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSDictionary *response = userInfo[@"aps"];
    if (response[@"content-available"]) {
        self.isRemoteNotification = YES;
        self.starterUserId = response[@"UserId"];
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
        }
        [self.locationManager startUpdatingLocation];
    }
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    if ([identifier isEqualToString:@"ACCEPT"]) {
        //Post an url
    }
}


#pragma mark - Location delegate methods

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    [[NetworkHandler sharedInstance] sendRideRequest:@{@"StartRiderUserId":[NetworkHandler sharedInstance].loginUserID,@"PickupRiderUserId":region.identifier,@"RequestStatus":@1} withURL:@"details/SendRideRequest" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
        if ([response[@"ErrorMessage"] isKindOfClass:[NSNull class]]) {
            
        }
        else{
            NSLog(@"Start ride got an error:%@",response[@"ErrorMessage"]);
        }
    }];
}


-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [NetworkHandler sharedInstance].userLocation = [locations firstObject];
    [self.locationManager stopUpdatingLocation];
    if (self.isRemoteNotification) {
        NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:@"CuB"];
        NSString *loginUserId = [defaults valueForKey:@"UserId"];
        __block NSString * latitute =[[NSNumber numberWithDouble:[NetworkHandler sharedInstance].userLocation.coordinate.latitude] stringValue];
        __block NSString * longitude = [[NSNumber numberWithDouble:[NetworkHandler sharedInstance].userLocation.coordinate.longitude] stringValue];
        [[NetworkHandler sharedInstance] saveLocationDetails:@{@"StartRiderUserId":self.starterUserId,@"PickupRiderUserId":loginUserId,@"Latitude":latitute,@"Longitude":longitude} withURL:@"details/UpdateUserLocation" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
            if (!error) {
                NSLog(@"Updated the location");
            }
        }];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}
@end
