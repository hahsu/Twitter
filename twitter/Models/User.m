//
//  User.m
//  twitter
//
//  Created by Hannah Hsu on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.numFollowers = dictionary[@"followers_count"];
        self.numFollowing = dictionary[@"friends_count"];
        self.numTweets = dictionary[@"statuses_count"];
        NSString *fullProfilePicURLString = dictionary[@"profile_image_url_https"];
        self.profilePicURL = [NSURL URLWithString:fullProfilePicURLString];
        NSString *fullBackgroundPicURLString = dictionary[@"profile_banner_url"];
        self.profileBackgroundURL = [NSURL URLWithString:fullBackgroundPicURLString];
    }
    return self;
}
@end
