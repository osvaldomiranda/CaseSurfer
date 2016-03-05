//
//  ParticipantsTableViewController.m
//  casesurfer
//
//  Created by Osvaldo Miranda on 16/12/15.
//  Copyright © 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "ParticipantsTableViewController.h"
#import "MedCase.h"
#import "ParticipantsTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface ParticipantsTableViewController ()

@end

@implementation ParticipantsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    participants = [[NSMutableArray alloc] init];
    [self readData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


-(void) readData{
    MedCase *medCase = [[MedCase alloc] init];
    [medCase find:self.caseId Success:^(NSMutableDictionary *items) {
        [self fillCase: items];
    } Error:^(NSError *error) {
    }];
}

-(void) fillCase: (NSMutableDictionary*) item{
    participants = [item valueForKeyPath:@"participants"];
    
    [self.tblParticipants reloadData];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return participants.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ParticipantCell";
    ParticipantsTableViewCell *cell = (ParticipantsTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ParticipantsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *celda;
    
    
    NSString *url;
    
    celda = [participants objectAtIndex:indexPath.row];
        
  //  NSDictionary *ppic= [celda valueForKeyPath:@"profile_pic"];
    NSDictionary *profile_pic = [celda valueForKeyPath:@"profile_pic"];
    NSDictionary *thumb = [profile_pic valueForKeyPath:@"thumb"];
    url = [thumb valueForKeyPath:@"url"];
        
    cell.lblUserName.text = [celda valueForKeyPath:@"name"];
    
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@", url];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [cell.imageAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    
    
    
    return cell;
}

@end
