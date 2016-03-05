//
//  MedCase.h
//  casesurfer
//
//  Created by Osvaldo on 03-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseApiModel.h"
#import "IndexableImageView.h"

@interface MedCase : BaseApiModel

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *album_id;
@property (nonatomic, retain) NSString *patient;
@property (nonatomic, retain) NSString *patient_age;
@property (nonatomic, retain) NSString *patient_gender;
@property (nonatomic, retain) NSString *descript;
@property (nonatomic, retain) NSString *stars;


@property (nonatomic, assign) NSMutableArray *images;


-(void) create;
-(void) edit;
@end
