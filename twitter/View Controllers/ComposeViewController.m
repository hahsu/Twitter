//
//  ComposeViewController.m
//  twitter
//
//  Created by Hannah Hsu on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"


@interface ComposeViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *composeView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property(strong, nonatomic)NSString *tweetContent;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.composeView.delegate = self;
    self.countLabel.text = [NSString stringWithFormat:@"%i", 140];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressedClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)pressedTweet:(id)sender {
    NSString *text = self.composeView.text;
    [[APIManager shared]postStatusWithText:text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}


- (void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length < 141){
        self.countLabel.text = [NSString stringWithFormat:@"%lu", 140 - textView.text.length];
        self.tweetContent = textView.text;
    }
    else{
        textView.text = self.tweetContent;
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
