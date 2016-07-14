//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Geoffrey Emerson on 11/12/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//
//  Abstracted.

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (nonatomic) Deck *deck;
@property (nonatomic, strong) CardMatchingGame *game;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeToggle;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck
{
    return nil; // This line makes this view controller "abstract"
}

- (IBAction)touchResetButton:(UIButton *)sender
{
    self.game = nil;
    self.modeToggle.selectedSegmentIndex = 0;
    [self updateUI];
}

- (IBAction)touchModeToggle:(UISegmentedControl *)sender
{
    if (self.modeToggle.selectedSegmentIndex == 0) {
        self.game.threeCardMode = NO;
    } else if (self.modeToggle.selectedSegmentIndex == 1) {
        self.game.threeCardMode = YES;
    }
    
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];   
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    self.modeToggle.enabled = !self.game.gameStarted;
    
    self.modeLabel.text = self.game.threeCardMode ? @"Three Card Mode" : @"Two Card Mode";
    
    self.resultLabel.text=@"";
    if (self.game.lastMatchCheck) {
        if (self.game.lastMatchSuccess) {
            self.resultLabel.text = @"Matched";
        }
    }
    for (Card *tempCard in self.game.chosenCardArray) {
        self.resultLabel.text = [[self.resultLabel.text stringByAppendingString:@" "] stringByAppendingString:tempCard.contents];
    }
    
    if (self.game.lastMatchCheck) {
        if (self.game.lastMatchSuccess) {
            self.resultLabel.text = [self.resultLabel.text stringByAppendingString:[NSString stringWithFormat:@" for %d points!", self.game.lastScore]];
        } else {
            self.resultLabel.text = [self.resultLabel.text stringByAppendingString:[NSString stringWithFormat:@" does not match! %d point penalty!", self.game.lastScore]];
        }
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
