//
//  MedCase.m
//  casesurfer
//
//  Created by Osvaldo on 03-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "MedCase.h"
#import "Definitions.h"
#import "session.h"
#import "IndexableImageView.h"

@implementation MedCase


-(void) create {
    
    NSDictionary *medcase = @{@"title": self.title,
                              @"album_id":self.album_id,
                              @"patient": self.patient,
                              @"patient_age": self.patient_age,
                              @"patient_gender": self.patient_gender,
                              @"description": self.descript,
                              @"stars": self.stars
                             };
    
    NSError *error;
    NSData *medcaseJson = [NSJSONSerialization dataWithJSONObject:medcase options:kNilOptions error:&error];
    NSString *medcaseString = [[NSString alloc] initWithData:medcaseJson encoding:NSUTF8StringEncoding];
    
    medcaseString = [[NSString stringWithFormat:@"%@", medcaseString] stringByReplacingOccurrencesOfString:@":" withString:@"=>"];
    medcaseString = [[NSString stringWithFormat:@"%@", medcaseString] stringByReplacingOccurrencesOfString:@"\"=>" withString:@"\"=>"];

    Session *sess = [[Session alloc] init];
    
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@%@",BASE_PATH,@"/medcases.json"]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------BOUNDARY-------";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"auth_token"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",[sess getToken]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"medcase"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n",medcaseString] dataUsingEncoding:NSUTF8StringEncoding]];
    
    int i=0;
    for (IndexableImageView *image in self.images) {
        NSData *imageData = UIImageJPEGRepresentation(image.image, 1.0);
        
        NSString *name = [NSString stringWithFormat:@"medcase_images_attributes[%d]",i];
        
        // add image data
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        i++;
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            NSString *resp = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                     NSLog(@"RESP %@",resp);
  //          successBlock(resp);
        }
    }];
    
}
    



@end
