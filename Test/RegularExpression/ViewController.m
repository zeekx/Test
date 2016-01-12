//
//  ViewController.m
//  RegularExpression
//
//  Created by yubinqiang on 15/11/25.
//  Copyright © 2015年 Zeek. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *sourceTextView;
@property (weak, nonatomic) IBOutlet UITextField *patternTextField;
@property (weak, nonatomic) IBOutlet UITextView *textCheckingTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)startCheck:(UIButton *)sender {
    NSString *pattern = self.patternTextField.text;
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:&error];


    if (error == nil && self.sourceTextView.text.length > 0) {
        self.patternTextField.textColor = [UIColor blackColor];
        NSArray<NSTextCheckingResult *> *results = [regularExpression matchesInString:self.sourceTextView.text
                                                                              options:kNilOptions
                                                                                range:NSMakeRange(0, self.sourceTextView.text.length)];
        NSMutableString *mutableString = [[NSMutableString alloc] initWithFormat:@"Find(%@):\n",@(results.count).stringValue];
        for (NSTextCheckingResult *result in results) {
            NSString *string = [self.sourceTextView.text substringWithRange:result.range];
            [mutableString appendString:[string stringByAppendingString:@"\n"]];
        }
        self.textCheckingTextView.text = mutableString;
    } else {
        self.patternTextField.textColor = [UIColor redColor];
    }

}

#pragma mark Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self startCheck:nil];
    return NO;
}
@end
