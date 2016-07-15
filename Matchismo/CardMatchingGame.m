//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Geoffrey Emerson on 11/14/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) long score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card; the game deck
@property (nonatomic, readwrite) BOOL gameStarted;
@property (nonatomic, readwrite) BOOL lastMatchCheck;
@property (nonatomic, readwrite) BOOL lastMatchSuccess;
@property (nonatomic, readwrite) long lastScore;
@property (nonatomic, readwrite) NSMutableArray *chosenCardArray;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    self.gameStarted = NO;
    self.threeCardMode = NO;
    self.lastMatchCheck = NO;
    return self;
}

- (NSMutableArray *)chosenCardArray
{
    if (!_chosenCardArray) _chosenCardArray = [[NSMutableArray alloc] init];
    return _chosenCardArray;
}

- (void)updateChosenCardArray {
    [self.chosenCardArray removeAllObjects];
    // NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    
    // Update the array holding all chosen cards.
    for (PlayingCard *tempCard in self.cards) {
        if (tempCard.isChosen && !tempCard.isMatched) {
            [self.chosenCardArray addObject:tempCard];
        }
    }
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    self.gameStarted = YES;
    
    PlayingCard *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {  // If a face up card is chosen
            card.chosen = NO; // turn in back over.
            [self updateChosenCardArray];
            self.lastMatchCheck = NO;
            self.lastScore = 0;
        } else {
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            
            [self updateChosenCardArray];
            
            // This line will need updating if the match mode ever allows more than 3
            int maxCards = self.threeCardMode ? 3 : 2;
            
            // see if the total number of chosen cards matches the game mode
            if (self.chosenCardArray.count == maxCards) {
                self.lastMatchCheck = YES;
                
                // match against other cards
                
                int matchScore = 0;
                int tempIndex = 0;
                
                // Iterate through the array, except for the last item
                // which would have nothing after it to match against
                
                while ( tempIndex < [self.chosenCardArray count]-1 ) {
                       
                    Card *tempCard = [self.chosenCardArray objectAtIndex:tempIndex];
                    
                    // Send the currently indexed card to PlayingCard:match
                    // to check for matches with any following card.
                    // Should work no matter how many cards are in the array.
                    
                    matchScore += [tempCard match:[self.chosenCardArray subarrayWithRange:NSMakeRange(tempIndex+1,[self.chosenCardArray count]-tempIndex-1)]];
                    tempIndex++;
                }
        
                if (matchScore) {
                    self.lastMatchSuccess = YES;
                    self.lastScore = matchScore * MATCH_BONUS;
                    self.score += self.lastScore;
                    //if any card matches, set all chosen cards to matched
                    for (Card *tempCard in self.chosenCardArray) {
                        tempCard.matched = YES;
                    }
                } else {
                    self.lastMatchSuccess = NO;
                    self.lastScore = MISMATCH_PENALTY;
                    self.score -= self.lastScore;
                    //if no cards matche, set all chosen cards to not chosen
                    for (Card *tempCard in self.chosenCardArray) {
                        if (tempCard != card) tempCard.chosen = NO;
                    }
                }
            } else {
                self.lastMatchCheck = NO;
            }
        }
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (instancetype)init
{
    return nil; //if somebody tried to init without the required variables
}

@end
