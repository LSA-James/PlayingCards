//
//  Untitled.swift
//  PlayingCards
//
//  Created by James Liu on 2025/5/22.
//

struct PlayingCard: CustomStringConvertible{
    
    var description: String{ return "\(rank)\(suit)" }
    
    var suit: Suit
    var rank: Rank
    
    enum Suit: String, CustomStringConvertible{
        var description: String{
            return self.rawValue
        }
        
        case spades = "♠️"
        case hearts = "❤️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        static var all:[Suit]{
            return [.spades,.hearts,.clubs,.diamonds]
        }
    }
    
    enum Rank: CustomStringConvertible{
        var description: String{
            switch self{
                case .ace: return "A"
                case .numerical(let pips): return "\(pips)"
                case .face(let face): return face
            }
        }
        
        case ace
        case numerical(Int)
        case face(String)
        
        var order: Int{
            switch self{
            case .ace: return 1
            case .numerical(let pips): return pips
            case .face(let face) where face == "J": return 11
            case .face(let face) where face == "Q": return 12
            case .face(let face) where face == "K": return 13
            default: return 0
            }
        }
        
        static var all: [Rank]{
            var allRank:[Rank] = [PlayingCard.Rank.ace]
            for pips in 2...10 {
                allRank.append(PlayingCard.Rank.numerical(pips))
            }
            allRank.append(PlayingCard.Rank.face("J"))
            allRank.append(PlayingCard.Rank.face("Q"))
            allRank.append(PlayingCard.Rank.face("K"))
            
            return allRank
        }
    }
    
}
