//
//  ContactViewController.m
//  MobiConnect
//
//  Created by vishwavijet on 2/24/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "ContactViewController.h"
#import "TableViewCell.h"
#import "NetworkHandler.h"
#import "UserModel.h"

@interface ContactViewController ()
@property(nonatomic,strong)NSMutableArray *locations;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       
    self.locations = [NSMutableArray new];
    NSString *url = [NSString stringWithFormat:@"details/GetAllUsersLocation?UserId=%@",[NetworkHandler sharedInstance].loginUserID];
    [[NetworkHandler sharedInstance] getUserLocations:url withMethod:@"GET" completionHandler:^(NSArray *response, NSError *error) {
        if (response.count > 0) {
            for(NSDictionary *dict in response){
                UserModel *user = [[UserModel alloc] initWithDictionary:dict];
                [self.locations addObject:user];
            }
        }
        else{
            NSLog(@"No users");
        }
    }];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section     {
    // Return the number of rows in the section.
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    }
    
    UserModel *user = [self.locations objectAtIndex:indexPath.row];
    cell.textLabel.text = user.FirstName;
    cell.detailTextLabel.text=user.EmailId;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    tableView.allowsMultipleSelection=YES;
    NSArray *selectedCells = [self.tabelView indexPathsForSelectedRows];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
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
