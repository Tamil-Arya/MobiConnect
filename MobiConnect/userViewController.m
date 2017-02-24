//
//  userViewController.m
//  MobiConnect
//
//  Created by vishwavijet on 2/24/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "userViewController.h"

#import "NetworkHandler.h"
@interface userViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ph_Number;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email_ID;
@property (weak, nonatomic) IBOutlet UITextField *dept;
@property (weak, nonatomic) IBOutlet UITextField *bio_id;
@property (weak, nonatomic) IBOutlet UITextField *hobbies;
@property (weak, nonatomic) IBOutlet UITextField *work;
@property (weak, nonatomic) IBOutlet UITextField *bloodGroup;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@end

@implementation userViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progress.hidden = NO;
    NSString *url = [NSString stringWithFormat:@"details/GetUserDetails?UserId=%@",[NetworkHandler sharedInstance].loginUserID];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        [[NetworkHandler sharedInstance] getUserDetailsWithURL:url withMethod:@"GET" completionHandler:^(NSDictionary *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progress.hidden = YES;
                if ([response[@"ErrorMessage"] isKindOfClass:[NSNull class]]) {
                    _email_ID.text=response[@"EmailId"];
                    _name.text=response[@"FirstName"];
                    _ph_Number.text=response[@"PhoneNumber"];
                    _dept.text=response[@"Department"];
                    _bio_id.text=response[@"Bio"];
                    _hobbies.text=response[@"Hobbies"];
                    _work.text=response[@"PreviousWorkExperience"];
                    _bloodGroup.text = response[@"BloodGroup"];
                }
            });
        }];
    });
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

-(IBAction)close:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
