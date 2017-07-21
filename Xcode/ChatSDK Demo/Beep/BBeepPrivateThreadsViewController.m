//
//  BBeepPrivateThreadsViewController.m
//  ChatSDK Demo
//
//  Created by Benjamin Smiley-andrews on 06/07/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BBeepPrivateThreadsViewController.h"
#import "BAdID.h"
#import "BBannerAdBuilder.h"

@interface BBeepPrivateThreadsViewController ()



@end

@implementation BBeepPrivateThreadsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BBannerAdBuilder bannerAddedToViewController:self];

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
