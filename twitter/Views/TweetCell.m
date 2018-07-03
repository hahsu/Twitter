//
//  TweetCell.m
//  twitter
//
//  Created by Hannah Hsu on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTweet:(Tweet *)tweet{
    _tweet = tweet;
    [self refreshData];
}
-(void)refreshData{
    User *user = self.tweet.user;
    self.authorLabel.text = user.name;
    NSString *fullScreenName = [NSString stringWithFormat:@"%@%@", @"@", user.screenName];
    self.handleLabel.text = fullScreenName;
    
    self.tweetLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.createdAtString;
    
    self.profilePic.image = nil;
    if (self.tweet.profilePicURL != nil) {
        [self.profilePic setImageWithURL:self.tweet.profilePicURL];
    }
    if(self.tweet.favoriteCount == 0){
        self.likeLabel.text = @"";
    }
    else{
        self.likeLabel.text = [NSString stringWithFormat: @"%i", self.tweet.favoriteCount];
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
        self.retweetLabel.text = @"";
    }
    else{
        self.retweetLabel.text = [NSString stringWithFormat:@"%i", self.tweet.retweetCount];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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





@end
