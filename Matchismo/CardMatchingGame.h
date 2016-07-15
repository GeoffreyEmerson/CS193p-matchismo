//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Geoffrey Emerson on 11/14/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "PlayingCardDeck.h"
#include "PlayingCard.h"

@interface CardMatchingGame : NSObject

// Designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (PlayingCard *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) long score;
@property (nonatomic) BOOL threeCardMode;
@property (nonatomic, readonly) BOOL gameStarted;
@property (nonatomic, readonly) BOOL lastMatchCheck;
@property (nonatomic, readonly) BOOL lastMatchSuccess;
@property (nonatomic, readonly) long lastScore;
@property (nonatomic, readonly) NSMutableArray *chosenCardArray;
@end
