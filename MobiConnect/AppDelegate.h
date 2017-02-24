//
//  AppDelegate.h
//  MobiConnect
//
//  Created by Tamil Selvan R on 24/02/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

