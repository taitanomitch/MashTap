//
//  MasterViewController.swift
//  MashTap
//
//  Created by Mitchell Taitano on 12/27/17.
//  Copyright © 2017 Mitchell Taitano. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var keyCollectionView: UICollectionView!
    @IBOutlet weak var totalScorelabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var highScoreTimeLabel: UILabel!
    
    
    // MARK: - Variables
    var colorsHolderArray: [Color] = []
    var score: Float = 0
    var startTime: NSDate = NSDate()
    var elapsedTime: TimeInterval = 0
    var hasStarted: Bool = false
    var timer: Timer = Timer()

    
    // MARK: - Enums
    enum Color {
        case NoColor
        case Purple
        case Red
        case Yellow
        case Blue
        case Green
        case Orange
    }

    enum ColorValue: String {
        case NoColor = "FFFFFF"
        case Purple = "EDB0F5"
        case Red = "FF6784"
        case Yellow = "FFE868"
        case Blue = "8992FF"
        case Green = "63ECB3"
        case Orange = "F1CA7B"
    }

    
    // MARK: - Loading Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for _ in 1...10 {
            colorsHolderArray.append(chooseRandomColor())
        }
        updateHighScoreLabel()
    }
    
    
    // MARK: - Button Functions
    @IBAction func TappedColorButton(_ sender: UIButton) {
        var matched = false
        if(sender.tag == 0 && colorsHolderArray[0] == Color.Purple) {
            matched = true
        }
        else if(sender.tag == 1 && colorsHolderArray[0] == Color.Red) {
            matched = true
        }
        else if(sender.tag == 2 && colorsHolderArray[0] == Color.Blue) {
            matched = true
        }
        else if(sender.tag == 3 && colorsHolderArray[0] == Color.Orange) {
            matched = true
        }
        else if(sender.tag == 4 && colorsHolderArray[0] == Color.Green) {
            matched = true
        }
        else if(sender.tag == 5 && colorsHolderArray[0] == Color.Yellow) {
            matched = true
        }
        
        if(matched) {
            colorsHolderArray.remove(at: 0)
            colorsHolderArray.append(chooseRandomColor())
            let startIndexPath = IndexPath(item: 0, section: 0)
            let endIndexPath = IndexPath(item: 9, section: 0)
            self.keyCollectionView.moveItem(at: startIndexPath, to: endIndexPath)
            self.keyCollectionView.reloadItems(at: [endIndexPath])
            
            updateScore()
            if(!hasStarted) {
                hasStarted = true
                startTime = NSDate()
                runTimer()
            }
        }
        else {
            if(hasStarted) {
                let highScore = UserDefaults.standard.float(forKey: "HighScore")
                if(score > highScore) {
                    UserDefaults.standard.set(score, forKey: "HighScore")
                    let highScoreTimeString = getHighScoreTimeString()
                    UserDefaults.standard.set(highScoreTimeString, forKey: "HighScoreTime")
                }
                resetScore()
                updateHighScoreLabel()
                timer.invalidate()
                timeLabel.text = "00:00:00"
                self.averageScoreLabel.text = "0 tpm"
                hasStarted = false
            }
        }
    }
    
    @IBAction func PressedResetButton(_ sender: UIButton) {
        UserDefaults.standard.set(0, forKey: "HighScore")
        UserDefaults.standard.set("00:00:00", forKey: "HighScoreTime")
        updateHighScoreLabel()
    }
    
    // MARK: - UICollectionViewDataSource Protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let basicCell : KeyCollectionViewCell = keyCollectionView.dequeueReusableCell(withReuseIdentifier: "KeyCollectionViewCell", for: indexPath) as! KeyCollectionViewCell
        basicCell.setUpCell(color: colorsHolderArray[indexPath.item])
        return basicCell
    }
    
    
    // MARK: - UICollectionViewDelegate Protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Do Nothing
    }
    
    
    // MARK: - Utility Functions
    func chooseRandomColor() -> Color {
        let randomNumber = arc4random_uniform(6) + 1
        switch randomNumber {
        case 1:
            return Color.Purple
        case 2:
            return Color.Red
        case 3:
            return Color.Yellow
        case 4:
            return Color.Blue
        case 5:
            return Color.Green
        case 6:
            return Color.Orange
        default:
            return Color.Blue
        }
    }
    
    func updateHighScoreLabel() {
        let highScore = UserDefaults.standard.float(forKey: "HighScore")
        highScoreLabel.text = "High Score: " + String(format: "%.0f", highScore)
        if(highScore > 0) {
            let highScoreTime = UserDefaults.standard.string(forKey: "HighScoreTime")
            highScoreTimeLabel.text = highScoreTime
        } else {
            highScoreTimeLabel.text = "00:00:00"
        }
    }
    
    func getHighScoreTimeString() -> String {
        let dateNow = NSDate()
        let secondsDuration = dateNow.timeIntervalSince(self.startTime as Date)
        let (hours, minutes, seconds) = self.convertSecondsToHoursMinutesSeconds(seconds: secondsDuration)
        let hoursString = String(format: "%02d", hours)
        let minutesString = String(format: "%02d", minutes)
        let secondsString = String(format: "%02d", seconds)
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
    
    func convertSecondsToHoursMinutesSeconds(seconds: TimeInterval) -> (Int, Int, Int) {
        let integerSeconds = Int(seconds)
        return (integerSeconds / 3600, (integerSeconds % 3600) / 60, (integerSeconds % 3600) % 60)
    }
    
    func updateScore() {
        score = score + 1
        totalScorelabel.text = String(format: "%.0f", score)
    }
    
    func resetScore() {
        score = 0;
        totalScorelabel.text = "0"
    }
    
    
    // MARK: - Timer Functions
    func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (myTimer) in
            let dateNow = NSDate()
            let secondsDuration = dateNow.timeIntervalSince(self.startTime as Date)
            let (hours, minutes, seconds) = self.convertSecondsToHoursMinutesSeconds(seconds: secondsDuration)
            let hoursString = String(format: "%02d", hours)
            let minutesString = String(format: "%02d", minutes)
            let secondsString = String(format: "%02d", seconds)
            
            
            let tpm: Int = Int((self.score * 60) / Float(secondsDuration))
            
            DispatchQueue.main.async {
                self.timeLabel.text = "\(hoursString):\(minutesString):\(secondsString)"
                self.averageScoreLabel.text = "\(tpm) tpm"
            }
        })
    }
}
