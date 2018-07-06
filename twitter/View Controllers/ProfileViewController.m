//
//  ProfileViewController.m
//  twitter
//
//  Created by Hannah Hsu on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numTweets;
@property (weak, nonatomic) IBOutlet UILabel *numFollowing;
@property (weak, nonatomic) IBOutlet UILabel *numFollowers;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[APIManager shared] getUserInfo:^(User *user, NSError *error) {
        if (user) {
            self.authorLabel.text = user.name;
            self.handleLabel.text = [NSString stringWithFormat:@"%@%@", @"@", user.screenName];
            self.numFollowers.text = [NSString stringWithFormat:@"%@", user.numFollowers];
            self.numFollowing.text = [NSString stringWithFormat:@"%@", user.numFollowing];
            self.numTweets.text = [NSString stringWithFormat:@"%@", user.numTweets];
            self.profilePic.image = nil;
            [self.profilePic setImageWithURL:user.profilePicURL];
            self.profilePic.layer.masksToBounds = YES;
            self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
            self.posterView.image = nil;
            if(user.profileBackgroundURL != nil){
                [self.posterView setImageWithURL:user.profileBackgroundURL];
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
    // Do any additional setup after loading the view.
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
