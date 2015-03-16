//
//  ViewController.swift
//  TheRealTicTacToe
//
//  Created by Antonio Rodrigues on 15/03/2015.
//  Copyright (c) 2015 Antonio Rodrigues. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    
    @IBOutlet weak var gameStatusLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    var perfectPlayer = PerfectPlayer.init(state:BoardState())
    
    var turn = 0
    var boardSpaces = [0, 0, 0, 0, 0, 0, 0, 0, 0]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameStatusLabel.text = "It's Circle's turn"
    }
    
    override func viewDidAppear(animated: Bool)
    {
        playAgainButton.alpha = 0
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        view.userInteractionEnabled = false
        if boardSpaces[sender.tag] == 0 && !perfectPlayer.isGameOver() {
            
            sender.setImage(UIImage(named: "Circle2.png")!, forState: UIControlState.Normal)
            boardSpaces[sender.tag] = 1

            turn++
            let (row:Int, col:Int) = translateMove(sender.tag)
            let m1: Dictionary! = move(row,col: col)
            perfectPlayer.performMove(m1)
            
            gameStatusLabel.text = "Wait... It's Cross' turn"
            
            if self.perfectPlayer.isGameOver() {
                self.testWinner()
                return
            }

            let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                let m2: AnyObject! = self.perfectPlayer.moveFromSearch(9 - self.turn)

                self.perfectPlayer.performMove(m2)
               
                let row2:Int = m2.objectForKey("row")!.integerValue
                let col2:Int = m2.objectForKey("col")!.integerValue
                let tMove = self.translateBackMove(row2, col: col2)
                self.boardSpaces[tMove] = 1
                var button:UIButton? = self.view.viewWithTag(tMove) as? UIButton
                if button != nil {
                    button!.setImage(UIImage(named: "Cross.png")!, forState: UIControlState.Normal)
                } else if tMove == 0 {
                    self.button0.setImage(UIImage(named: "Cross.png")!, forState: UIControlState.Normal)
                }
                
                self.testWinner()
                
            }
            
            
        }
        
    }
    
    @IBAction func playAgainButtonPressed(sender: UIButton)
    {
        
        boardSpaces = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        gameStatusLabel.text = "It's Circle's turn"
        playAgainButton.alpha = 0
        turn = 0
        perfectPlayer = PerfectPlayer.init(state:BoardState())
        
        button0.setImage(nil, forState: UIControlState.Normal)
        button1.setImage(nil, forState: UIControlState.Normal)
        button2.setImage(nil, forState: UIControlState.Normal)
        button3.setImage(nil, forState: UIControlState.Normal)
        button4.setImage(nil, forState: UIControlState.Normal)
        button5.setImage(nil, forState: UIControlState.Normal)
        button6.setImage(nil, forState: UIControlState.Normal)
        button7.setImage(nil, forState: UIControlState.Normal)
        button8.setImage(nil, forState: UIControlState.Normal)
        
    }
    
    // MARK: Helpers
    
    func testWinner() -> () {
        self.gameStatusLabel.text = "It's Circle's turn"
        self.view.userInteractionEnabled = true
        if perfectPlayer.isGameOver() {
            if perfectPlayer.winner() == 2 {
                gameStatusLabel.text = "Cross wins!"
                gameStatusLabel.center = CGPointMake(view.center.x, gameStatusLabel.center.y)
                UIView.animateWithDuration(0.5, animations:
                    {
                        self.gameStatusLabel.center = CGPointMake(self.view.center.x, self.gameStatusLabel.center.y)
                        self.playAgainButton.alpha = 1
                    }
                )

            } else {
                gameStatusLabel.text = "It's a draw!"
                gameStatusLabel.center = CGPointMake(view.center.x, gameStatusLabel.center.y)
                UIView.animateWithDuration(0.5, animations:
                    {
                        self.gameStatusLabel.center = CGPointMake(self.view.center.x, self.gameStatusLabel.center.y)
                        self.playAgainButton.alpha = 1
                    }
                )

            }
            
        }

    }
    
    func translateMove(tag: Int) -> (row:Int, col:Int) {
        if tag == 0 {
            return (0,0)
        } else if tag == 1 {
            return (0,1)
        } else if tag == 2 {
            return (0,2)
        } else if tag == 3 {
            return (1,0)
        } else if tag == 4 {
            return (1,1)
        } else if tag == 5 {
            return (1,2)
        } else if tag == 6 {
            return (2,0)
        } else if tag == 7 {
            return (2,1)
        } else  { //tag == 8
            return (2,2)
        }
    }
    
    func translateBackMove(row: Int, col: Int) -> Int {
        if row == 0 && col == 0 {
            return 0
        } else if row == 0 && col == 1 {
            return 1
        } else if row == 0 && col == 2 {
            return 2
        } else if row == 1 && col == 0 {
            return 3
        } else if row == 1 && col == 1 {
            return 4
        } else if row == 1 && col == 2 {
            return 5
        } else if row == 2 && col == 0 {
            return 6
        } else if row == 2 && col == 1 {
            return 7
        } else { //if row == 2 && col == 2 {
            return 8
        }
    }
    
    
    func move(row: Int, col: Int) -> NSDictionary! {
        let dict:NSDictionary = ["row":NSNumber(integer: row),"col":NSNumber(integer: col)]
        return dict
    }


}

