//
//  ParticipantsTableViewCell.h
//  casesurfer
//
//  Created by Osvaldo Miranda on 16/12/15.
//  Copyright © 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticipantsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;

/*@property (weak, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblDone;
*/
@end
