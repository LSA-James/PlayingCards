//
//  PlayingCardDeck.swift
//  PlayingCards
//
//  Created by James Liu on 2025/5/23.
//

import Foundation

struct PlayingCardDeck{
    var cards = [PlayingCard]()
    
    mutating func draw() -> PlayingCard?{
        if cards.count > 0 {
            return cards.remove(at: cards.count.random())
        }
        //push到github
        print("hello")
        print("h")
        print("this is dev branch")
        return nil
    }
    
    
    init() {
        for rank in PlayingCard.Rank.all {
            for suit in PlayingCard.Suit.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
}

extension Int{
    func random() -> Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(self)))
        }else{
            return 0
        }
    }
}
