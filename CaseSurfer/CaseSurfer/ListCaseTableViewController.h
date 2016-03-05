//
//  ListCaseTableViewController.h
//  casesurfer
//
//  Created by Osvaldo on 09-10-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCaseTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>{
    NSMutableArray *itemsArray;
}

@property (nonatomic, assign) int albumId;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong,nonatomic) NSMutableArray *filteredUserArray;
@property (strong,nonatomic) NSMutableArray *usersArray;


- (IBAction)editCase:(id)sender;

@end
