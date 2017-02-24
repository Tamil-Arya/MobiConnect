//
//  RideStartViewController.m
//  MobiConnect
//
//  Created by vishwavijet on 2/24/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "RideStartViewController.h"
#import "UserModel.h"
#import "NetworkHandler.h"

@interface RideStartViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)NSMutableArray *locations;
@end

@implementation RideStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.mapView.delegate = self;
    self.locations = [NSMutableArray new];
    NSString *url = [NSString stringWithFormat:@"details/GetAllUsersLocation?UserId=%@",[NetworkHandler sharedInstance].loginUserID];
    [[NetworkHandler sharedInstance] getUserLocations:url withMethod:@"GET" completionHandler:^(NSArray *response, NSError *error) {
        if (response.count > 0) {
            for(NSDictionary *dict in response){
                UserModel *user = [[UserModel alloc] initWithDictionary:dict];
                [self startMonitoring:user];
                [self.locations addObject:user];
                [self.mapView addAnnotation:user.locationModel];
            }
        }
        else{
            NSLog(@"No users");
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location delegate methods
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        self.mapView.showsUserLocation = YES;
    }
}

-(void)startMonitoring:(UserModel *)model{
    if (![CLLocationManager isMonitoringAvailableForClass:[model class]]) {
        //Error
    }
    else if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways){
        //Error
    }
    else{
        CLRegion *region = [[CLCircularRegion alloc] initWithCenter:model.locationModel.coordinate radius:model.locationModel.radius identifier:model.UserId];
        region.notifyOnEntry = YES;
        [self.locationManager startMonitoringForRegion:region];
    }
}


#pragma mark - MakpView
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay{
    
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *renderer = [[MKCircleRenderer alloc ]initWithCircle:overlay];
        renderer.lineWidth = 1.0;
        renderer.strokeColor = [UIColor purpleColor];
        renderer.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
        return renderer;
    }else{
        return [[MKOverlayRenderer alloc] initWithOverlay:overlay];
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[UserModel class]]) {
        MKAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annoteIdentifier"];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annoteIdentifier"];
            annotationView.canShowCallout = YES;
            UIButton *remove = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
            [remove setImage:[UIImage imageNamed:@"buttonImage"] forState:UIControlStateNormal];
            [annotationView setLeftCalloutAccessoryView:remove];
        }
        else{
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    UserLocationModel *model = (UserLocationModel*)view.annotation;
    NSString *user = model.userId;
    [self pushNotificationForUser:user];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    UserLocationModel *model = (UserLocationModel*)view.annotation;
    NSString *user = model.userId;
    [self pushNotificationForUser:user];
}


-(void)pushNotificationForUser:(NSString *)userID{
    [[NetworkHandler sharedInstance] sendRideRequest:@{@"StartRiderUserId":[NetworkHandler sharedInstance].loginUserID,@"PickupRiderUserId":userID,@"RequestStatus":@1} withURL:@"details/SendRideRequest" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
        if ([response[@"ErrorMessage"] isKindOfClass:[NSNull class]]) {
            
        }
        else{
            NSLog(@"Start ride got an error:%@",response[@"ErrorMessage"]);
        }
    }];
}


-(void)zoomToUserLocation{
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.1;
    mapRegion.span.longitudeDelta = 0.1;
    
    [self.mapView setRegion:mapRegion animated: YES];
}

- (IBAction)cancelRide_Btn:(id)sender {
    [[NetworkHandler sharedInstance] endRideWithDetails:@{@"StartRiderUserId":[NetworkHandler sharedInstance].loginUserID,@"PickupRiderUserId":@0} withURL:@"details/EndRide" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

@end
