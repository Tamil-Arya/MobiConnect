//
//  EmployeeRideShareViewController.m
//  MobiConnect
//
//  Created by vishwavijet on 2/24/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "EmployeeRideShareViewController.h"
#import "SWRevealViewController.h"
#import "NetworkHandler.h"



@interface EmployeeRideShareViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@property (weak, nonatomic) IBOutlet UIButton *ride_Btn;
@property (weak, nonatomic) IBOutlet UITextField *sourceLocation_TextField;
@property (weak, nonatomic) IBOutlet UITextField *destination_TextField;
@property ( weak, nonatomic) IBOutlet UIActivityIndicatorView *progress;

@end

@implementation EmployeeRideShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    // Do any additional setup after loading the view.
    self.progress.hidden = YES;
    UITapGestureRecognizer *hideKeyBoard=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:hideKeyBoard];
    self.sourceLocation_TextField.text = @"Fetching…";
    self.destination_TextField.text = @"Kormanagala, Bengaluru South";
    
    // Do something...
    __block NSString * location;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:[NetworkHandler sharedInstance].userLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = placemarks.firstObject;
        location = [NSString stringWithFormat:@"%@, %@",place.subLocality,place.locality];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sourceLocation_TextField.text = location;
        });
    }];

}
- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: self.revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)updateUserLocation{
    if ([NetworkHandler sharedInstance].userLocation) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            __block NSString * latitute =[[NSNumber numberWithDouble:[NetworkHandler sharedInstance].userLocation.coordinate.latitude] stringValue];
            __block NSString * longitude = [[NSNumber numberWithDouble:[NetworkHandler sharedInstance].userLocation.coordinate.longitude] stringValue];
            [[NetworkHandler sharedInstance] saveLocationDetails:@{@"UserId":[NetworkHandler sharedInstance].loginUserID,@"Latitude":latitute,@"Longitude":longitude} withURL:@"details/SaveUserLocation" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
                if (!error) {
                    
                }
            }];
        });
    }
}


-(void)hideKeyBoard{
    
}


-(IBAction)startRide:(id)sender{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Start Ride" message:@"Do wish to notify to all other employees about your ride?" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progress.hidden = NO;
        });
        
        [[NetworkHandler sharedInstance] startRideWithDetails:@{@"UserID":[NetworkHandler sharedInstance].loginUserID} withURL:@"details/StartRide" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progress.hidden = YES;
                UIAlertController *secondAlertVC = [UIAlertController alertControllerWithTitle:@"Ride Started" message:@"We have informed about your ride to all employees!" preferredStyle:UIAlertControllerStyleAlert];
                [secondAlertVC addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self performSegueWithIdentifier:@"startRide" sender:self];
                }]];
                [self presentViewController:secondAlertVC animated:YES completion:nil];
                
            });
            
        }];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"User dismissed ride");
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}
@end
