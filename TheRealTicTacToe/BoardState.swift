//
//  BoardState.swift
//  TheRealTicTacToe
//
//  Created by Antonio Rodrigues on 15/03/2015.
//  Copyright (c) 2015 Antonio Rodrigues. All rights reserved.
//

import Foundation

class BoardState : NSCopying {
    
    var board = [[Int]](count: 3, repeatedValue: [Int](count: 3, repeatedValue: 0))
    var player:UInt!
    
    init() {
        for var i = 0; i < 3; i++ {
            for var j = 0; j < 3; j++ {
                board[i][j] = 0
            }
        }
        player = 1
    }
    
    init(boardState:BoardState) {
        board = boardState.board
        player = boardState.player
    }
    
    func winner() -> Int {
        var t1 = 3, t2 = 3
        for var i = 0; i < 3; i++ {
            var j: Int, tv = 3, th = 3
            for j = 0; j < 3; j++ {
                th = th & board[i][j]
                tv = tv & board[j][i]
            }
            if tv != 0 || th != 0 {
                return tv + th
            }
            t1 = t1 & board[i][i]
            t2 = t2 & board[i][2 - i]
        }
        if t1 != 0 || t2 != 0 {
            return t1 + t2
        }
        
        return 0
    }
    
    func isDraw() -> Bool {
        return (winner() == 0)
    }
    
    
    func isWin() -> Bool {
        return winner() == Int(player)
    }

    
    func calcFitness(me: Int, counts:[Int]) -> Double {
        let you = 3 - me;
        var score:Double = 0.0
        if counts[me] != 0 && counts[you] == 0 {
            score += Double((UInt8(counts[me]) * UInt8(counts[you])))
        } else if counts[me] == 0 && counts[you] != 0 {
            score -= Double(UInt8(counts[you]) * UInt8(counts[you]))
        }
        return abs(score) == 9 ? score * 100 : score
    }
    
    func fitness() -> Double {
        var i:Int, j:Int, me:Int
        var score:Double = 0.0
        var countd1:[Int] = [0, 0, 0]
        var countd2:[Int] = [0, 0, 0]
        
        me = Int(player)
        for i = 0; i < 3; i++ {
            var counth:[Int] = [0, 0, 0]
            var countv:[Int] = [0, 0, 0]
            for j = 0; j < 3; j++ {
                counth[board[i][j]]++
                countv[board[j][i]]++
            }
            countd1[board[i][i]]++
            countd2[board[i][2 - i]]++
            score += calcFitness(me, counts: counth)
            score += calcFitness(me, counts: countv)
        }
        score += calcFitness(me, counts: countd1)
        score += calcFitness(me, counts: countd2)
        return score
    }

    func legalMoves() -> NSArray {
        var moves:NSMutableArray = NSMutableArray()
        if abs(fitness()) > 100 {
            return moves
        }
        for var i = 0; i < 3; i++ {
            for var j = 0; j < 3; j++ {
                if board[i][j] == 0 {
                    moves.addObject(["row":NSNumber(integer: j),"col":NSNumber(integer: i)])
                }
            }
        }
        return moves
    }
    
    
    func description() -> String {
        var desc:NSMutableString = NSMutableString()
        for var i = 0; i < 3; i++ {
            for var j = 0; j < 3; j++ {
                desc.appendFormat("%d", board[j][i])
            }
            if i < 2 {
                desc.appendString(" ")
            }
        }
        return desc
    }

    func applyMove(move: AnyObject) -> () {
        var row = Int(move.objectForKey("row")!.intValue)
        var col = Int(move.objectForKey("col")!.intValue)
        if row > 2 || row < 0 || col > 2 || col < 0 {
            // This will cause the app to crash but this state should never happen
            // We can cover this by testing the app
            var error: NSError?
            NSException.raise("This is not a valid move", format: "Invalid move (\(row), \(col))", arguments: getVaList([error ?? "nil"]))
        } else if (board[col][row] != 0) {
            // This will cause the app to crash but this state should never happen
            // We can cover this by testing the app
            var error: NSError?
            NSException.raise("This square is already taken", format: "Move already taken (\(row), \(col))", arguments: getVaList([error ?? "nil"]))
        }
        board[col][row] = Int(player)
        player = 3 - player
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        return BoardState(boardState: self)
    }
    
    func copy() -> AnyObject! {
        if let asCopying = ((self as AnyObject) as? NSCopying) {
            return asCopying.copyWithZone(nil)
        }
        else {
            assert(false, "This class doesn't implement NSCopying")
            return nil
        }
    }
        
    func undoMove(move:AnyObject) -> () {
        var row = Int(move.objectForKey("row")!.intValue)
        var col = Int(move.objectForKey("col")!.intValue)
        
        if row > 2 || row < 0 || col > 2 || col < 0 {
            // This will cause the app to crash but this state should never happen
            // We can cover this by testing the app
            var error: NSError?
            NSException.raise("This is not a valid move", format: "Invalid move (\(row), \(col))", arguments: getVaList([error ?? "nil"]))
        } else if (board[col][row] == 0) {
            // This will cause the app to crash but this state should never happen
            // We can cover this by testing the app
            var error: NSError?
            NSException.raise("This square is already taken", format: "Move already taken (\(row), \(col))", arguments: getVaList([error ?? "nil"]))
        }
        
        board[col][row] = 0
        player = 3 - player
    }

    
}
