//
//  CommentViewController.m
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "MedCase.h"
#import "Definitions.h"
#import "UIImageView+WebCache.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.comments = [[NSArray alloc] init];
    MedCase *medCase = [[MedCase alloc] init];
    [medCase find:self.caseId Success:^(NSMutableDictionary *items) {
        [self fillCase: items];
    } Error:^(NSError *error) {
    }];
}

-(void) fillCase: (NSMutableDictionary*) item{
    self.comments = [item valueForKeyPath:@"comments"];
    [self.tblComments reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
    [cell.contentView clearsContextBeforeDrawing];
    cell.callerViewController = self;
    
    NSDictionary *celda = [self.comments objectAtIndex:indexPath.row];
    
    cell.lblMessage.text  = [celda valueForKeyPath:@"message"];
    cell.btnUserName.titleLabel.text = [celda valueForKeyPath:@"user_name"];
    
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@", [celda valueForKeyPath:@"thumbnail"]];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [cell.imgUserAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    
    return cell;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
