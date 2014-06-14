//
//  CLYSystemSounds.m
//  AngryPena
//
//  Created by Carlos Eduardo López Mercado on 6/14/14.
//  Copyright (c) 2014 Carlos Eduardo López Mercado. All rights reserved.
//

#import "CLYSystemSounds.h"
@import AVFoundation; //THIS IS NEW IN IOS 7. This let us to use frameworks without going to the app panel and choose them one by one

#define INFINITE -1

@interface CLYSystemSounds()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) AVAudioPlayer *speak;

@end

@implementation CLYSystemSounds

+ (instancetype)sharedSystemSounds {
    static dispatch_once_t onceToken;
    static CLYSystemSounds *shared;

    //let create a singleton

    dispatch_once(&onceToken, ^{
        shared = [[CLYSystemSounds alloc] init];
    });

    return shared;
}

- (void)punch {

}

- (void)startTomatoes {
    self.player = [self playFileName: @"splat" extension:@"wav" numberOfLoops:INFINITE];
    if(self.player){
        [self.player play];
    }

}

- (void)stopTomatoes {
    [self.player stop];

}

- (void)worstEnglishSpeakingEver {
    self.speak = [self playFileName: @"pena_speaking" extension:@"mp3" numberOfLoops:INFINITE];
    if(self.speak){
        [self.speak play];
    }

}

- (void)putTape {
    [self.speak stop];
}

- (void)removeTape {
    [self.speak play];
}

-(AVAudioPlayer *) playFileName:(NSString *) name
           extension:(NSString *)extension
       numberOfLoops:(int) loops{



    NSURL *url = [[NSBundle mainBundle] URLForResource: name
                                         withExtension:extension];

    NSError *error = nil;

    AVAudioPlayer *avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url
                                                         error:&error];

    if(avAudioPlayer){
        //there's no error with the new instance of the audio
        avAudioPlayer.numberOfLoops = loops;

    } else{
        NSLog(@"Error reading %@: %@", url, error);
    }

    return avAudioPlayer;
}


@end
