//
//  PerfectPlayer.swift
//  TheRealTicTacToe
//
//  Created by Antonio Rodrigues on 15/03/2015.
//  Copyright (c) 2015 Antonio Rodrigues. All rights reserved.
//

// This is an implementation of the AplhaBeta algorithm
// http://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning

import Foundation

class PerfectPlayer {
    
    var stateHistory:NSMutableArray
    var moveHistory:NSMutableArray
    
    var statesVisited:UInt = 0
    var foundEnd:Bool = false
    

    init(state:AnyObject) {
        stateHistory = NSMutableArray(array: [state])
        moveHistory = NSMutableArray()
    }
    
    func successorByAppying(move: AnyObject, state:BoardState) -> AnyObject {
        
        state.applyMove(move)
        return state
    }
    

    func undoApplying(move: AnyObject, state:BoardState) -> () {
        state.undoMove(move)
    }
    

    func alphaBeta(currentState:BoardState, inout alpha:Double, beta:Double, plyLeft:UInt) -> Double {
        statesVisited++
        
        if plyLeft == 0 {
            foundEnd = false
            return currentState.fitness()
        }
        
        var moves = currentState.legalMoves()
        if moves.count == 0 {
            return currentState.fitness()
        }
        
        for var i = 0; i < moves.count; i++ {
            var move:AnyObject = moves[i]
            let successor: AnyObject = successorByAppying(move, state: currentState)
            var invertAlpha = -alpha
            var invertBeta = -beta
            var score = alphaBeta(successor as BoardState, alpha: &invertBeta, beta: invertAlpha, plyLeft: plyLeft - 1)
            score = -score
            undoApplying(move, state: successor as BoardState)
            
            alpha = alpha > score ? alpha : score
            
            if alpha >= beta {
                return alpha
            }
        }
        
        return alpha
    }


    func moveFromSearch(depth:UInt) -> AnyObject? {
        var alpha:Double = -Double.infinity
        var beta:Double = +Double.infinity
        
        if depth < 1 {
            var error:NSError?
            NSException.raise("Depth too low", format: "Depth must be 1 or greater", arguments: getVaList([error ?? "nil"]))
        }
        
        statesVisited = 0
        var best:AnyObject?
        var current:BoardState = currentState().copy() as BoardState
        
        var moves:NSArray = current.legalMoves()
        for var i = 0;depth != 0 && i < moves.count; i++ {
            var move:AnyObject = moves[i]
            let successor: AnyObject = successorByAppying(move, state: current)
            var invertAlpha = -alpha
            var invertBeta = -beta
            var score = alphaBeta(successor as BoardState, alpha: &invertBeta, beta: invertAlpha, plyLeft: depth - 1)
            score = -score
            undoApplying(move, state: successor as BoardState)
            if score > alpha {
                alpha = score
                best = move
            }

        }
        
        
        
        return best
    }
    
 
    func performMove(move:AnyObject) -> BoardState {
        var moves = currentLegalMoves()
        
        if NSNotFound == moves.indexOfObject(move) {
            var error:NSError?
            NSException.raise("Ilegal move", format: "This is not a legal move \(move)", arguments: getVaList([error ?? "nil"]))
        }
        
        var state:BoardState = currentState().copy() as BoardState
        
        state.applyMove(move)
        stateHistory.addObject(state)
        moveHistory.addObject(move)
        return state
    }
    
    

    func undoLastMove() -> BoardState {
        moveHistory.removeLastObject()
        stateHistory.removeLastObject()
        return currentState()
    }
    
    func currentState() -> BoardState {
        return stateHistory.lastObject! as BoardState
    }

    func lastMove() -> AnyObject {
        return moveHistory.lastObject!
    }
    


    func countPerformedMoves() -> UInt {
        return UInt(moveHistory.count)
    }
    
    
    func currentPlayer() -> UInt {
        return (countPerformedMoves() % 2) + 1
    }
    

    //Will return 1 or 2 for the winning player or 0 if draw
    func winner() -> UInt {
        if !isGameOver() {
            var error:NSError?
            NSException.raise("The game is not over", format: "Cannot determine winner; game has not ended yet", arguments: getVaList([error ?? "nil"]))
        }
        
        var state:BoardState = currentState()
        if state.isDraw() {
            return 0
        }
        return state.isWin() ? currentPlayer() : 3 - currentPlayer()
        
    }
    

    func isGameOver() -> Bool {
        return currentLegalMoves().count > 0 ? false : true
    }
    

    func stateCountForSearch() -> UInt {
        return statesVisited
    }
    

    func currentFitness() -> Double {
        return currentState().fitness()
    }


    func currentLegalMoves() -> NSArray {
        return currentState().legalMoves()
    }
    
}


