//
//  ShareTableViewCell.h
//  casesurfer
//
//  Created by Osvaldo on 15-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTableViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id callerViewController;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *caseName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *caseImage;
@property (assign, nonatomic) int caseId;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) NSString *status;
@property (weak, nonatomic) IBOutlet UIButton *btnAcept;
@property (weak, nonatomic) IBOutlet UIButton *btnIgnore;


- (IBAction)userAction:(id)sender;
- (IBAction)caseAction:(id)sender;

- (IBAction)aceptAction:(id)sender;
- (IBAction)ignoreAction:(id)sender;

@end
