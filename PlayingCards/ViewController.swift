//
//  ViewController.swift
//  PlayingCards
//
//  Created by James Liu on 2025/5/22.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck.init()
    
    @IBOutlet weak var playingCardView: PlayingCardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\(PlayingCard.Rank.all)")
        print("\(PlayingCard.Suit.all)")
        print("")
        for _ in 0..<10 {
            if let card = deck.draw(){
                print(card)
            }
        }
        playingCardView.backgroundColor = UIColor.clear
        //playingCardView.contentMode = UIView.ContentMode.redraw
    }
}
