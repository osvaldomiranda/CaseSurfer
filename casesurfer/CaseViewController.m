//
//  CaseViewController.m
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CaseViewController.h"
#import "CaseTableViewCell.h"
#import "CommentViewController.h"
#import "Definitions.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MedCase.h"
#import "UIImageView+WebCache.h"
#import "GaleryViewController.h"
#import "GroupsShareViewController.h"
#import "ShareUsersTableViewController.h"
#import "ShareViewController.h"
#import "CommentTableViewCell.h"
#import "session.h"
#import "Mosaic.h"
#import "Utilities.h"
#import "UpdateCaseTableView.h"
#import "CaseDescripViewController.h"
#import "ParticipantsTableViewController.h"



@interface CaseViewController ()

@end

@implementation CaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.comments = [[NSMutableArray alloc] init];
    self.participants = [[NSMutableArray alloc] init];
    self.scrollPrueba.contentSize =  CGSizeMake(self.scrollPrueba.contentSize.width, 950);
    self.scrollPrueba.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self readData];
    [self.tblComments reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setToptButtons{

        UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(editCase:)];
        [self.navigationItem setRightBarButtonItem:rItem animated:YES];
 
}

-(void) readData{
    MedCase *medCase = [[MedCase alloc] init];
    [medCase find:self.caseId Success:^(NSMutableDictionary *items) {
        self.medCase = items;
        [self fillCase: items];
    } Error:^(NSError *error) {
    }];
}


-(void) fillCase: (NSMutableDictionary*) item{
    
   // NSLog(@"ITEM %@",item);
    
    NSString *patient =  [item valueForKeyPath:@"patient"];
    self.ownerUser = [[item valueForKeyPath:@"user_id"] intValue];
    
    Session *session= [[Session alloc] init];
    int myId =  [session.getUserId intValue];
    
    if (myId == self.ownerUser) {
        self.shareButton.hidden = NO;
        [self setToptButtons];
    } else{
        self.shareButton.hidden = YES;
        patient = [self anonimize: [item valueForKeyPath:@"patient"]];
    }
    
    self.txtTitle.text = [item valueForKeyPath:@"title"];
    self.txtDescription.text = [item valueForKeyPath:@"description"];
    NSString *gender = [item valueForKeyPath:@"patient_gender"];
    NSString *age = [item valueForKeyPath:@"patient_age"];
    self.lblData.text = [NSString stringWithFormat:@"%@, %@, %@ years old", patient, gender, age ];
    self.comments = [item valueForKeyPath:@"comments"];
    self.participants = [item valueForKeyPath:@"participants"];
  //  [self orderArray:self.comments];
    self.images = [item valueForKeyPath:@"medcase_images"];
    
    NSString *lblPartic = [NSString stringWithFormat:@"%lu Participants", (unsigned long)self.participants.count ];
    if (self.participants.count == 1) {
        lblPartic = [NSString stringWithFormat:@"%lu Participant", (unsigned long)self.participants.count ];
    }
    

    
    self.lblParticipants.text = lblPartic;
    
    [self setMosaic];
    [self.tblComments reloadData];
}

- (void) orderArray:(NSMutableArray *) arr{
    NSSortDescriptor *hopProfileDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
    
    NSArray *descriptors = [NSArray arrayWithObjects:hopProfileDescriptor, nil];
    NSArray *sortedArrayOfDictionaries = [arr sortedArrayUsingDescriptors:descriptors];
    
    [self.comments removeAllObjects];
    for (NSMutableDictionary *item in sortedArrayOfDictionaries) {
        [self.comments addObject:item];
    }
    
}

-(void) setMosaic{
    
    int x = (SCREEN_WIDTH / 2) - 115 ;
    
    CGRect mosaicFrame = CGRectMake(x -30 , 150, 230, 345);
    if ([self.images count]<3) {
        mosaicFrame = CGRectMake(x , 150, 230, 345);
    }
    Mosaic *mosaicView = [[Mosaic alloc] initMosaic:self.images frameView: mosaicFrame];
    
    UIButton *clearButton = [[UIButton alloc] init];
    [clearButton addTarget:self action:@selector(largeImage:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setTitleColor:[UIColor clearColor]forState:UIControlStateNormal];
    [clearButton setBackgroundColor:[UIColor clearColor]];
    clearButton.frame = mosaicView.frame;
    
    [self.scrollPrueba addSubview:mosaicView];
    [self.scrollPrueba addSubview:clearButton];
}




- (IBAction)comment:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Comments"];
    cController.caseId = self.caseId;
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}

- (IBAction)callLargeImage:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GaleryViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Galery"];
    cController.images = self.images;
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
    
}


- (IBAction)largeImage:(id)sender {
    [self callLargeImage:self];
}

- (IBAction)share:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ShareViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Share"];
    
    cController.caseId = self.caseId;
    
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
    
  /*  NSString *string = @"Organize, share and discuss medical cases, A web and mobile AppCaseSurfer";
    NSURL *Url = [NSURL URLWithString:[@"http://casesurfer.com/" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[string, Url] applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypePostToWeibo,
                                   UIActivityTypePrint,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo,
                                   UIActivityTypePostToTencentWeibo,
                                   UIActivityTypeAirDrop];;
    
    activityViewController.excludedActivityTypes = excludeActivities;
    
    [self.navigationController presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                        
                                     }];
   */
}

- (IBAction)participants:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ParticipantsTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Participants"];
    cController.caseId = self.caseId;
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}





- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    NSDictionary *celda = [self.comments objectAtIndex:indexPath.row];
    return [self textH:[celda valueForKeyPath:@"message"]] + 50;
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
    
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@%@",DEV_BASE_PATH, [celda valueForKeyPath:@"thumbnail"]];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [cell.imgUserAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    cell.lblUserName.text = [celda valueForKeyPath:@"user_name"];
    

    Utilities *util = [[Utilities alloc] init];
    cell.txtMessage.text  = [celda valueForKeyPath:@"message"];
    [cell.txtMessage sizeToFit];
    [cell.txtMessage setScrollEnabled:NO];
    cell.TextViewHeightConstraint.constant = [self textH:[celda valueForKeyPath:@"message"]] -25 ;

    for ( UIView *view in cell.subviews ) {
        if (view.tag == 1) {
            [view removeFromSuperview];
        }
    }
    UIView *sep = [util addSeparator:[self textH:[celda valueForKeyPath:@"message"]]+40];
    [cell addSubview:sep];
    
    return cell;
}


- (int) textH: (NSString *) text
{
    Utilities *util = [[Utilities alloc] init];
    float height = [util labelHeightWith:text width:300 font:[UIFont systemFontOfSize:14.0]];
    return height+40;
}

- (IBAction)editCase:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UpdateCaseTableView *cController = [storyBoard instantiateViewControllerWithIdentifier:@"UpdateCase"];
    cController.medCase = self.medCase;
    cController.photos = self.images;
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}


- (IBAction)descript:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CaseDescripViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"CaseDescript"];
  
   
    cController.descripText = self.txtDescription.text;
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}

- (NSString *)anonimize:(NSString *) fullname {
    
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [fullname componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters appendString:[firstLetter uppercaseString]];
        }
    }
    
    return firstCharacters;
}

@end
