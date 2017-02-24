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


@interface BroadCastViewController ()< UITextViewDelegate >
- (IBAction)chooseContact_Btn:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@end

@implementation BroadCastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customSetup];
    self.textView.delegate=self;
    self.textView.layer.borderWidth=2.0;
    self.textView.layer.borderColor=[UIColor blueColor].CGColor;
    
    UITapGestureRecognizer *hideKeyBoard=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:hideKeyBoard];
    
}

- (void)hideKeyBoard{
    [self.textView resignFirstResponder];
  }
- (IBAction)shareMessage:(id)sender {
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Success" message:@"Message has sent to all" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OK=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
        
    }];
    
  
    [alert addAction:OK];
    [self presentViewController:alert animated:YES completion:nil];
    
    
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

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Save what you need here
    [coder encodeObject: _text forKey: @"text"];
    [coder encodeObject: _color forKey: @"color"];

    [super encodeRestorableStateWithCoder:coder];
}


- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Restore what you need here
    _color = [coder decodeObjectForKey: @"color"];
    _text = [coder decodeObjectForKey: @"text"];
    
    [super decodeRestorableStateWithCoder:coder];
}


- (void)applicationFinishedRestoringState
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Call whatever function you need to visually restore
    [self customSetup];
}

- (IBAction)chooseContact_Btn:(id)sender {
   
    [self performSegueWithIdentifier:@"contact" sender:self];

}
-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqualToString:@"Share message,..."]) {
        self.textView.text = @"";
        // self.totalTextCountLabel.text=@"";
        self.textView.font=[UIFont systemFontOfSize:20];
        self.textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.textView.text.length == 0){
        self.textView.textColor = [UIColor blackColor];
        self.textView.font=[UIFont systemFontOfSize:15];
        self.textView.text = @"Share message,...";
        [self.textView resignFirstResponder];
        
    }
}

@end
