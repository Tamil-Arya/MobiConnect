//
//  EmployeeRideViewController.m
//  MobiConnect
//
//  Created by Tamil Selvan R on 24/02/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "EventShareViewController.h"
#import "SWRevealViewController.h"
#import "EventShareTableViewCell.h"


@interface EventShareViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) NSArray *locations;
@end

@implementation EventShareViewController{
    NSMutableArray *allEvent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    // Do any additional setup after loading the view.
    self.events = [NSArray arrayWithObjects:@"Hackathon",@"Cricket league",@"Google Conference", nil];
    self.locations = [NSArray arrayWithObjects:@"Mobinius, Banglore",@"HSR ground, Bangalore",@"Whitefield, BLR", nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section     {
    // Return the number of rows in the section.
    return self.events.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    EventShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    }
    
    cell.textLabel.text = [self.events objectAtIndex:indexPath.row];
    cell.detailTextLabel.text=[self.locations objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)addNewEvent:(NSMutableArray *)newEventData{
    
   // [tableArray addObject:newString];
   // [tableView reloadData];
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
- (IBAction)createEvent:(id)sender {
     [self performSegueWithIdentifier:@"createEvent" sender:self];
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


@end
