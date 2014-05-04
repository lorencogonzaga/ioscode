//
//  HMSBCustomInfoWindow.h
//  HelloMapStoryboard
//
//  Created by Lorenco Gonzaga on 04/05/14.
//  Copyright (c) 2014 Example. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMSBCustomInfoWindow : UIView

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UIWebView *pcWeb;

@end
