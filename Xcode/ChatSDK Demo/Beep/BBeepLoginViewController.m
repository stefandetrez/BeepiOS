//
//  BBeepLoginViewController.m
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-andrews on 06/07/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BBeepLoginViewController.h"

@interface BBeepLoginViewController ()

@end

@implementation BBeepLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.facebookButton.keepHeight.equal = 0 + keepRequired;
    self.twitterButton.keepHeight.equal = 0 + keepRequired;
    self.googleButton.keepHeight.equal = 0 + keepRequired;
    self.anonymousButton.keepHeight.equal = 0 + keepRequired;
    
    self.chatImageView.image = [UIImage imageNamed:@"web_hi_res_512.png"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
