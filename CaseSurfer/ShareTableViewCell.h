//
//  ShareTableViewCell.h
//  casesurfer
//
//  Created by Osvaldo on 15-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol acctionToShareDelegate <NSObject>
- (void)accept:(NSString *) notificationId;
- (void)ignore:(NSString *) notificationId;
@end

@interface ShareTableViewCell : UITableViewCell

@property (nonatomic, assign) id<acctionToShareDelegate> delegate;

@property (nonatomic, unsafe_unretained) id callerViewController;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *caseName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *caseImage;
@property (assign, nonatomic) int caseId;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;
@property (weak, nonatomic) NSString *status;
@property (weak, nonatomic) IBOutlet UIButton *btnAcept;
@property (weak, nonatomic) IBOutlet UIButton *btnIgnore;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeAgo;
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) NSString *notificableId;
@property (nonatomic, assign) NSString *notificationId;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TextViewWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *lblWantToShare;

- (IBAction)userAction:(id)sender;
- (IBAction)caseAction:(id)sender;

- (IBAction)aceptAction:(id)sender;
- (IBAction)ignoreAction:(id)sender;

@end
