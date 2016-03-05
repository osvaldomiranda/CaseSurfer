//
//  ListCasesViewController.h
//  casesurfer
//
//  Created by Osvaldo on 01-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCasesViewController : UIViewController{
    NSMutableArray *itemsArray;
}

@property (nonatomic, assign) int albumId;
@property (weak, nonatomic) IBOutlet UITableView *listCaseTableView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)back:(id)sender;
- (IBAction)editCase:(id)sender;
- (IBAction)editAlbum:(id)sender;
@end
