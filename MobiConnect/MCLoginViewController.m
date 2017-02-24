//
//  MCLoginViewController.m
//  MobiConnect
//
//  Created by Tamil Selvan R on 24/02/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "MCLoginViewController.h"
#import "NetworkHandler.h"

@interface MCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *email_TextField;
@property (weak, nonatomic) IBOutlet UITextField *password_TextField;
@property (weak, nonatomic) IBOutlet UIButton *login_Btn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@end

@implementation MCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progress.hidden = YES;
    UITapGestureRecognizer *hideKeyBoard=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:hideKeyBoard];
    
    // Do any additional setup after loading the view.
}


-(void)hideKeyBoard{
    [self.email_TextField resignFirstResponder];
    [self.password_TextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)login_Btn:(id)sender {
    
   if ([self.email_TextField.text length] > 0 && [self.password_TextField.text length] > 0){
        
       
        self.progress.hidden = NO;
        [[NetworkHandler sharedInstance] loginUserwithDetails:@{@"Username":self.email_TextField.text,@"Password":self.password_TextField.text} withURL:@"Details/Login" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progress.hidden = YES;
                if ([response[@"ErrorMessage"] isKindOfClass:[NSNull class]]) {
                    [NetworkHandler sharedInstance].loginUserID = response[@"UserId"];
                    NSUserDefaults *defaults=[[NSUserDefaults alloc] initWithSuiteName:@"CuB"];
                    [defaults setObject:[NetworkHandler sharedInstance].loginUserID forKey:@"UserId"];
                    [defaults synchronize];
                    [self registerDevice];
                    [self performSegueWithIdentifier:@"loginIdentifier" sender:self];
                }
                else{
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please provide valid values" preferredStyle:UIAlertControllerStyleAlert];
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertVC animated:YES completion:nil];
                }
            });
            
        }];
    }else{
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Please provide valid values" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}


-(void)registerDevice{
    //Register the device
    if ([NetworkHandler sharedInstance].deviceToken.length > 0) {
        [[NetworkHandler sharedInstance] registerDeviceTokenWithDetails:@{@"UserId":[NetworkHandler sharedInstance].loginUserID,@"Token":[NetworkHandler sharedInstance].deviceToken} withURL:@"details/SaveDeviceToken" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
            if (!error) {
                NSLog(@"Device Registration Success");
                [self updateUserLocation];
            }
        }];
    }
    else{
        NSLog(@"Device Registration failed");
    }
}

-(void)updateUserLocation{
    if ([NetworkHandler sharedInstance].userLocation) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            // Do something...
            __block NSString * latitute =[[NSNumber numberWithDouble:[NetworkHandler sharedInstance].userLocation.coordinate.latitude] stringValue];
            __block NSString * longitude = [[NSNumber numberWithDouble:[NetworkHandler sharedInstance].userLocation.coordinate.longitude] stringValue];
            [[NetworkHandler sharedInstance] saveLocationDetails:@{@"UserId":[NetworkHandler sharedInstance].loginUserID,@"Latitude":latitute,@"Longitude":longitude} withURL:@"details/SaveUserLocation" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
                if (!error) {
                    
                }
            }];
        });
    }
}
@end
