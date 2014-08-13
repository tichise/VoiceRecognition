//
//  ViewController.m
//  VoiceRecognition
//
//  Created by tichise on 2014年8月13日 14/08/13.
//  Copyright (c) 2014年 tichise. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self generateLanguageModel];
    [self setupVoiceRecognization];
    [self startListening];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)generateLanguageModel {
    NSArray *words = [[NSArray alloc] initWithArray:[NSArray arrayWithObjects:
                                                                  @"Weather",
                                                                  @"Temperature",
                                                                  @"Shot",
                                                                  @"Hello",
                                                                  nil]];
    
    LanguageModelGenerator *languageModelGenerator = [[LanguageModelGenerator alloc] init];
    NSError *error = [languageModelGenerator generateLanguageModelFromArray:words withFilesNamed:@"OpenEarsDynamicGrammar" forAcousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"]];
    
    
    
    if (error.code != noErr) {
        NSLog(@"Error: %@",[error localizedDescription]);
    } else {
        NSDictionary *languageGeneratorResults = [error userInfo];
        
        _languageModelPath = [languageGeneratorResults objectForKey:@"LMPath"];
        _dictionaryPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
    }
}

-(void)setupVoiceRecognization {
    
    if (_languageModelPath && _dictionaryPath) {
    } else {
        NSString *resorcePath = [[NSBundle mainBundle] resourcePath];
        _languageModelPath = [NSString stringWithFormat:@"%@/%@", resorcePath, @"OpenEars1.languagemodel"];
        _dictionaryPath = [NSString stringWithFormat:@"%@/%@", resorcePath, @"OpenEars1.dic"];
    }
    
    self.pocketsphinxController = [[PocketsphinxController alloc] init];
    self.openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
    [self.openEarsEventsObserver setDelegate:self];
}

- (void)startListening {
    [_pocketsphinxController startListeningWithLanguageModelAtPath:_languageModelPath dictionaryAtPath:_dictionaryPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
}

- (void)stopListening {
    [self.pocketsphinxController stopListening];
}

- (void)pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
    NSLog(@"-----------------------------");
	NSLog(@"hypothesis is %@", hypothesis);
    NSLog(@"score is %@ and ID is %@", recognitionScore, utteranceID);
    

    
    // 半角スペースを区切りとして文字列を分割
    NSArray *hypothesisArray = [hypothesis componentsSeparatedByString:@" "];
    for (NSString *word in hypothesisArray) {
        NSLog(@"%@", word);
    }
    
    _voiceTextLabel.text = hypothesisArray[0];
}

@end
