//
//  ProfileViewController.m
//  MobiConnect
//
//  Created by Tamil Selvan R on 24/02/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "NetworkHandler.h"


@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ph_Number;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (weak, nonatomic) IBOutlet UITextField *email_ID;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UIButton *dismiss;
- (IBAction)dismiss:(id)sender;
@end

@implementation ProfileViewController
@synthesize ph_Number,name,email_ID,gender,dismiss;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    NSString *url = [NSString stringWithFormat:@"details/GetUserDetails?UserId=%@",[NetworkHandler sharedInstance].loginUserID];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [[NetworkHandler sharedInstance] getUserDetailsWithURL:url withMethod:@"GET" completionHandler:^(NSDictionary *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([response[@"ErrorMessage"] isKindOfClass:[NSNull class]]) {
                    email_ID.text=response[@"EmailId"];
                    name.text=response[@"FirstName"];
                    ph_Number.text=response[@"PhoneNumber"];
                    gender.text=response[@"Gender"];
                }
            });
        }];
    });
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
