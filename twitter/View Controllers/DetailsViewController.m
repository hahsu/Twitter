//
//  DetailsViewController.m
//  twitter
//
//  Created by Hannah Hsu on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
     
    // Do any additional setup after loading the view.
}

-(void)refreshData{
    User *user = self.tweet.user;
    self.authorLabel.text = user.name;
    NSString *fullScreenName = [NSString stringWithFormat:@"%@%@", @"@", user.screenName];
    self.handleLabel.text = fullScreenName;
    
    self.tweetLabel.text = self.tweet.text;
    //self.dateLabel.text = self.tweet.createdAtString;
    
    self.profilePic.image = nil;
    if (self.tweet.profilePicURL != nil) {
        [self.profilePic setImageWithURL:self.tweet.profilePicURL];
        self.profilePic.layer.masksToBounds = YES;
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
    }
    
    if(self.tweet.favoriteCount == 0){
        [self.likeButton setTitle:@"" forState:UIControlStateNormal];
        //self.likeLabel.text = @"";
    }
    else{
        [self.likeButton setTitle:[NSString stringWithFormat: @"%i", self.tweet.favoriteCount] forState:UIControlStateNormal];
        //self.likeLabel.text = [NSString stringWithFormat: @"%i", self.tweet.favoriteCount];
    }
    
    if(self.tweet.favorited == YES){
        UIImage *image = [UIImage imageNamed:@"favor-icon-red"];
        [self.likeButton setImage:image forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [UIImage imageNamed:@"favor-icon"];
        [self.likeButton setImage:image forState:UIControlStateNormal];
    }
    
    if(self.tweet.retweetCount == 0){
        [self.retweetButton setTitle:@"" forState:UIControlStateNormal];
        //self.retweetLabel.text = @"";
    }
    else{
        [self.retweetButton setTitle:[NSString stringWithFormat: @"%i", self.tweet.favoriteCount] forState:UIControlStateNormal];
        //self.retweetLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
    }
    if(self.tweet.retweeted == YES){
        UIImage *image = [UIImage imageNamed:@"retweet-icon-green"];
        [self.retweetButton setImage:image forState:UIControlStateNormal];
    }
    else{
        UIImage *image = [UIImage imageNamed:@"retweet-icon"];
        [self.retweetButton setImage:image forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)didTapLike:(id)sender {
    if(self.tweet.favorited == YES){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -=1;
        [self refreshData];
        [[APIManager shared]unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        }];
    }
    else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self refreshData];
        [[APIManager shared]favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        }];
    }
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted == YES){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -=1;
        [self refreshData];
        [[APIManager shared]unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error != nil){
                NSLog(@"It didn't worked!");
            }
            else{
                NSLog(@"It worked!");
            }
        }];
    }
    else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self refreshData];
        [[APIManager shared]retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        }];
    }
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
