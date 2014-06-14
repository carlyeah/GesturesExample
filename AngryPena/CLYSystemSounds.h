//
//  CLYSystemSounds.h
//  AngryPena
//
//  Created by Carlos Eduardo López Mercado on 6/14/14.
//  Copyright (c) 2014 Carlos Eduardo López Mercado. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLYSystemSounds : NSObject

+(instancetype) sharedSystemSounds;
-(void) punch;
-(void) startTomatoes;
-(void) stopTomatoes;
-(void) worstEnglishSpeakingEver;
-(void) putTape;
-(void) removeTape;

@end
