//
//  PlayingCard.m
//  Matchismo
//
//  Created by Geoffrey Emerson on 11/13/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    // Must test for cards in otherCards. This isn't one of those
    // passive fail situations.
    if ([otherCards count] >= 1) {

        // Compare the self card with each card in the passed array.
        // Note this does not match cards in the passed array with
        // each other, just the self card.

        for (PlayingCard *otherCard in otherCards) {
            if ([self.suit isEqualToString:otherCard.suit]){
                score += 1;
            }
            if (self.rank == otherCard.rank){
                score += 4;
            }
        }
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    NSString *_contents = [rankStrings[self.rank] stringByAppendingString:self.suit];
    return _contents;
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {return [[self rankStrings] count]-1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
