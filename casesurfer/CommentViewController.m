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
#import "UIAlertView+Block.h"
#import "NSString+Validation.h"
#import "Comment.h"
#import "Utilities.h"

UITextView *txtComment;
UIView *commentView;
@interface CommentViewController ()

@end


@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    self.comments = [[NSArray alloc] init];
    [self readData];
    [self setViewComment];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [commentView removeFromSuperview];
}

- (void) setViewComment{
    
    Utilities *util = [[Utilities alloc] init];
    
    commentView = [[UIView alloc] init];
    commentView.frame = CGRectMake(0, [util screenHeight] -50, [util screenWidth], 70);
    
    commentView.backgroundColor = graySep;
    
    txtComment = [[UITextView alloc] init];
    txtComment.frame = CGRectMake(5, 5, 300, 60);
    txtComment.backgroundColor = [UIColor whiteColor];
    txtComment.layer.cornerRadius = 4;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(send:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Send" forState:UIControlStateNormal];
    button.frame = CGRectMake(310, 15, 60, 40.0);
    
    
    [commentView addSubview: button];
    [commentView addSubview: txtComment];
    [[UIApplication sharedApplication].keyWindow addSubview:commentView];
}


-(void) readData{
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
    cell.txtMessage.text  = [celda valueForKeyPath:@"message"];
    cell.lblUserName.text = [celda valueForKeyPath:@"user_name"];
    
    Utilities *util = [[Utilities alloc] init];
    cell.txtMessage.frame = CGRectMake(11, 50, [util screenWidth] -20, [self textH:[celda valueForKeyPath:@"message"]] -25 );
    
    for ( UIView *view in cell.subviews ) {
        if (view.tag == 1) {
            [view removeFromSuperview];
        }
    }
    UIView *sep = [util addSeparator:[self textH:[celda valueForKeyPath:@"message"]]+40];
    [cell addSubview:sep];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [txtComment resignFirstResponder];
}

//"comment"=>{"message"=>"Este es un comentario", "medcase_id"=>"12"}

- (IBAction)send:(id)sender {
    if (![txtComment.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Comment."];
    } else {
       
        NSDictionary *commentData = @{@"message": txtComment.text,
                                    @"medcase_id": [NSString stringWithFormat:@"%d",self.caseId]
                                    };
        
        NSMutableDictionary *commentParams =  @{@"comment" : commentData}.mutableCopy;
        
        
        Comment *comment = [[Comment alloc] init];
        
        [comment save:commentParams withSession:TRUE Success:^(NSMutableDictionary *items) {
            txtComment.text = @"";
            [self readData];
            [self.tblComments reloadData];
        } Error:^(NSError *error) {
        }];
        
    }
}

- (void)keyboardWillChange:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    long animation = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
 
    CGRect new_frame = commentView.frame;
    new_frame.origin.y = keyboardRect.origin.y-5;
   
    [UIView beginAnimations:@"MoveView" context:nil];
    [UIView setAnimationCurve:animation];
    [UIView setAnimationDuration:duration];
    
    commentView.frame = new_frame;
    
    [UIView commitAnimations];
}

- (int) textH: (NSString *) text
{
    Utilities *util = [[Utilities alloc] init];
    float height = [util labelHeightWith:text width:300 font:[UIFont systemFontOfSize:14.0]];
    return 12+17+3+height+5;
}

@end
