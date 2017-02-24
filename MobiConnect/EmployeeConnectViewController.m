//
//  EmployeeViewController.m
//  MobiConnect
//
//  Created by Tamil Selvan R on 24/02/17.
//  Copyright © 2017 mobinius. All rights reserved.
//

#import "EmployeeConnectViewController.h"
#import "SWRevealViewController.h"
#import "userCellCollectionViewCell.h"
#import "ProfileViewController.h"

@interface EmployeeConnectViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView;
@end

@implementation EmployeeConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
    // Do any additional setup after loading the view.
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

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"profileIdentifier";
    
    userCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.profileImage.image = [UIImage imageNamed:@"profile"];
    
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"userIdentifier" sender:self];
    });
    
}
@end
