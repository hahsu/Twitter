//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "DetailsViewController.h"
#import "InfiniteScrollActivityView.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property(nonatomic, strong) InfiniteScrollActivityView* loadingMoreView;
@property(nonatomic) int count;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView insertSubview:refreshControl atIndex:0];
    // Get timeline
    
    // calling the block dfined in APIManager.m
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        
        // completion part
        if (tweets) {
            self.tweets = tweets;
            [self.tweetTableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }count:self.count];
    
    CGRect frame = CGRectMake(0, self.tweetTableView.contentSize.height, self.tweetTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.tweetTableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.tweetTableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tweetTableView.contentInset = insets;
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // Create NSURL and NSURLRequest
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            [self.tweetTableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }count:self.count];
    [self.tweetTableView reloadData];
    
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[DetailsViewController class] ]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tweetTableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tweet;
    }
    else{
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
}





- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tweet Cell"];
    [cell setTweet:self.tweets[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}


-(void)didTweet:(Tweet *)post{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.tweets];
    [array addObject:post];
    self.tweets = [array copy];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [self beginRefresh:refreshControl];
    [self.tweetTableView reloadData];
}

- (IBAction)tappedLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tweetTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tweetTableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tweetTableView.isDragging) {
            self.count += 20;
            self.isMoreDataLoading = YES;
            CGRect frame = CGRectMake(0, self.tweetTableView.contentSize.height, self.tweetTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            // Code to load more results
            [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
                if (tweets) {
                    self.isMoreDataLoading = NO;
                    self.tweets = tweets;
                    [self.tweetTableView reloadData];
                    [self.loadingMoreView stopAnimating];
                    
                } else {
                    NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
                }
            }count:self.count];
        }
    }
}


@end
