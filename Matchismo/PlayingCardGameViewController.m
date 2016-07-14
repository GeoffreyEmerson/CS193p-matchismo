//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Geoffrey Emerson on 12/17/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
