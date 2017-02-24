//
//  CreateEventViewController.m
//  MobiConnect
//
//  Created by vishwavijet on 2/24/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "CreateEventViewController.h"
#import "EventShareViewController.h"

@interface CreateEventViewController ()
@property (weak, nonatomic) IBOutlet UITextField *event_Name;
@property (weak, nonatomic) IBOutlet UITextField *eventDate;
@property (weak, nonatomic) IBOutlet UITextView *event_Description;
@property (nonatomic) UIDatePicker *dpDatePicker;

- (IBAction)createEvent:(id)sender;

@end

@implementation CreateEventViewController{
    EventShareViewController *EventShare;
    NSMutableArray *newEventArray;
}
@synthesize dpDatePicker,eventDate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    newEventArray=[[NSMutableArray alloc]init];
    dpDatePicker = [[UIDatePicker alloc] init];
    EventShare=[[EventShareViewController alloc]init];
    dpDatePicker.datePickerMode = UIDatePickerModeDate;
    [dpDatePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    dpDatePicker.timeZone = [NSTimeZone defaultTimeZone];
    dpDatePicker.minuteInterval = 5;
    [eventDate setInputView:dpDatePicker];
    
    self.event_Description.layer.borderWidth=2.0;
    self.event_Description.layer.borderColor=[UIColor blueColor].CGColor;
    
    self.event_Name.layer.borderWidth=2.0;
    self.event_Name.layer.borderColor=[UIColor blueColor].CGColor;
    
    self.eventDate.layer.borderWidth=2.0;
    self.eventDate.layer.borderColor=[UIColor blueColor].CGColor;
    
    
    UITapGestureRecognizer *hideKeyBoard=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyBoard)];
    [self.view addGestureRecognizer:hideKeyBoard];
      // Do any additional setup after loading the view.
}
- (void)hideKeyBoard{
    [self.dpDatePicker resignFirstResponder];
    [self.event_Name resignFirstResponder];
    [self.event_Description resignFirstResponder];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)datePickerValueChanged:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM:DD:YYYY"];
    self.eventDate.text = [dateFormatter stringFromDate:dpDatePicker.date];
}
- (IBAction)createEvent:(id)sender {
   [self dismissViewControllerAnimated:YES completion:^{
       
       [EventShare addNewEvent:newEventArray];
       
   }];
}
-(BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.event_Description.text isEqualToString:@"Share message,..."]) {
        self.event_Description.text = @"";
        // self.totalTextCountLabel.text=@"";
        self.event_Description.font=[UIFont systemFontOfSize:20];
        self.event_Description.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.event_Description.text.length == 0){
        self.event_Description.textColor = [UIColor blackColor];
        self.event_Description.font=[UIFont systemFontOfSize:15];
        self.event_Description.text = @"Share message,...";
        [self.event_Description resignFirstResponder];
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
