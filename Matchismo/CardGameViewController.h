//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Geoffrey Emerson on 11/12/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//
//  Abstract class. Must implement methods as described below.

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController
- (Deck *)createDeck; // Abstract

@end
