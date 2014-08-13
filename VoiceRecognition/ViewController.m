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
        
        self.lmPath = [languageGeneratorResults objectForKey:@"LMPath"];
        self.dicPath = [languageGeneratorResults objectForKey:@"DictionaryPath"];
    }
}

-(void)setupVoiceRecognization {
    
    if (_lmPath && _dicPath) {
    } else {
        NSString *resorcePath = [[NSBundle mainBundle] resourcePath];
        _lmPath = [NSString stringWithFormat:@"%@/%@", resorcePath, @"OpenEars1.languagemodel"];
        _dicPath = [NSString stringWithFormat:@"%@/%@", resorcePath, @"OpenEars1.dic"];
    }
    
    self.pocketsphinxController = [[PocketsphinxController alloc] init];
    self.openEarsEventsObserver = [[OpenEarsEventsObserver alloc] init];
    [self.openEarsEventsObserver setDelegate:self];
}

- (void)startListening {
    [_pocketsphinxController startListeningWithLanguageModelAtPath:_lmPath dictionaryAtPath:_dicPath acousticModelAtPath:[AcousticModel pathToModel:@"AcousticModelEnglish"] languageModelIsJSGF:NO];
}

- (void)pocketsphinxDidReceiveHypothesis:(NSString *)hypothesis recognitionScore:(NSString *)recognitionScore utteranceID:(NSString *)utteranceID {
    
    NSLog(@"-----------------------------");
	NSLog(@"hypothesis is %@", hypothesis);
    NSLog(@"score is %@ and ID is %@", recognitionScore, utteranceID);
    
    _voiceTextLabel.text = hypothesis;
}

@end
