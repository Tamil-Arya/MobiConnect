//
//  ColorViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "BroadCastViewController.h"
#import "SWRevealViewController.h"
#import "TableViewCell.h"
#import "NetworkHandler.h"

@interface BroadCastViewController ()< UITextViewDelegate >
- (IBAction)chooseContact_Btn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *textView;
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic) IBOutlet UIActivityIndicatorView * progress;
@end

@implementation BroadCastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customSetup];
    self.progress.hidden = YES;
    UITapGestureRecognizer *hideKeyBoard=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:hideKeyBoard];
    
}

- (void)hideKeyBoard{
    [self.textView resignFirstResponder];
  }

- (IBAction)shareMessage:(id)sender {
    self.progress.hidden = NO;
    [[NetworkHandler sharedInstance] sendBroadcastWithDetails:@{@"UserId":[NetworkHandler sharedInstance].loginUserID,@"Message":self.textView.text} withURL:@"details/SendBroadcastMessage" withMethod:@"POST" completionHandler:^(NSDictionary *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progress.hidden = YES;
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Success" message:@"Message has sent to all" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *OK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:OK];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}
- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
    
    _label.text = _text;
    _label.textColor = _color;
}


#pragma mark state preservation / restoration

- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}

- (IBAction)chooseContact_Btn:(id)sender {
   
    [self performSegueWithIdentifier:@"contact" sender:self];

}


@end
