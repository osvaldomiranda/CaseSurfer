//
//  ShareViewController.m
//  casesurfer
//
//  Created by Osvaldo on 15-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "ShareViewController.h"
#import "SearchUser.h"
#import "SearchGroup.h"
#import "MedCase.h"
#import "UIAlertView+Block.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    
    self.usersShare = [[NSMutableArray alloc] init];
    self.groupsShare = [[NSMutableArray alloc] init];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
- (void)addElementToShare:(NSString *)userId userName:(NSString *)userName name:(NSString *)name {
    SearchUser *sUser = [[SearchUser alloc] initWithName:name andId:userId username:userName];
  
    [self addUserToArray:sUser];
    [self fillUsersText];
}

- (void) addUserToArray:(SearchUser *)user{
    BOOL find=false;
    for (SearchUser *u in self.usersShare) {
        if (u.idUser == user.idUser) {
            find = true;
        }
    }
    if (!find) {
     [self.usersShare addObject:user];
    }
}


-(void) fillUsersText{
    int i=0;
    self.txvUsers.text =@"";
    for (SearchUser *user in self.usersShare) {
        if(i==0){
            self.txvUsers.text = user.name;
        }
        else{
            self.txvUsers.text = [NSString stringWithFormat:@"%@, %@",self.txvUsers.text, user.name];
        }
        i++;
    }
}


- (IBAction)deleteLast:(id)sender {
    [self.usersShare removeLastObject];
    [self fillUsersText];
}


- (void)addGroupToShare:(NSString *)groupId
              groupName:(NSString *)groupName{
    SearchGroup *sGroup = [[SearchGroup alloc] initWithName:groupName andId:groupId];
    
    [self addGroupToArray:sGroup];
    [self fillGroupsText];
}

- (void) addGroupToArray:(SearchGroup *)group{
    BOOL find=false;
    for (SearchGroup *u in self.groupsShare) {
        if (u.idGroup == group.idGroup) {
            find = true;
        }
    }
    if (!find) {
        [self.groupsShare addObject:group];
    }
}


-(void) fillGroupsText{
    int i=0;
    self.txtGroups.text =@"";
    for (SearchGroup *group in self.groupsShare) {
        if(i==0){
            self.txtGroups.text = group.name;
        }
        else{
            self.txtGroups.text = [NSString stringWithFormat:@"%@, %@",self.txtGroups.text, group.name];
        }
        i++;
    }
}

- (IBAction)addUsers:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ShareUsersTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"SearchUserShare"];
    
    cController.delegate = self;
    
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}

- (IBAction)addGroups:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GroupsShareViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"GroupsShare"];
    
    cController.delegate = self;
    
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:cController animated:YES];
}

- (IBAction)deleteLastGroup:(id)sender {
    [self.groupsShare removeLastObject];
    [self fillGroupsText];
}

- (IBAction)share:(id)sender {
    
    
    if ((self.usersShare.count>0) || (self.groupsShare.count>0) ) {
        NSMutableArray *groups_ids = [self groupsIds];
        NSString *receivers = [self getReceivers];
        NSMutableDictionary *shareData = @{@"groups_ids":groups_ids,
                                           @"shares_receivers_ids": receivers,
                                           }.mutableCopy;
        NSMutableDictionary *medcaseParams =  @{@"medcase" : shareData}.mutableCopy;
        MedCase *medcase = [[MedCase alloc] init];
        [medcase update:self.caseId params:medcaseParams Success:^(NSMutableDictionary *items) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Your case has been shared!"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            
            [self.navigationController popViewControllerAnimated:TRUE];
        } Error:^(NSError *error) {
            
        }];
    }
    
    
}

-(NSMutableArray *) groupsIds{
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    
    for (SearchGroup *group in self.groupsShare) {
        [groups addObject: [NSString stringWithFormat:@"%@", group.idGroup]];
    }
    return groups;
}

-(NSString *) getReceivers {
    NSString *receiv = @"";
    int i=0;
    for (SearchUser *user in self.usersShare) {
        if(i==0){
            receiv = [NSString stringWithFormat:@"[%@] - %@", user.username, user.username];
        }
        else{
            receiv = [NSString stringWithFormat:@"%@,[%@] - %@",receiv, user.username, user.username];
        }
        i++;
    }
    return receiv;
}
@end
