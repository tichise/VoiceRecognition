//
//  ViewController.h
//  VoiceRecognition
//
//  Created by tichise on 2014年8月13日 14/08/13.
//  Copyright (c) 2014年 tichise. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenEars/LanguageModelGenerator.h>
#import <OpenEars/PocketsphinxController.h>
#import <OpenEars/OpenEarsLogging.h>
#import <OpenEars/AcousticModel.h>

@class PocketsphinxController;

@interface ViewController : UIViewController<OpenEarsEventsObserverDelegate> {
    IBOutlet UILabel *_voiceTextLabel;
}

@property (strong, nonatomic) NSString *lmPath;
@property (strong, nonatomic) NSString *dicPath;
@property (strong, nonatomic) PocketsphinxController *pocketsphinxController;
@property (strong, nonatomic) OpenEarsEventsObserver *openEarsEventsObserver;

@end
