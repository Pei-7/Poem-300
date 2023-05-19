//
//  ViewController.swift
//  Poem 300
//
//  Created by 陳佩琪 on 2023/5/17.
//

import UIKit
import AVFAudio



class ViewController: UIViewController {
    
    let themeBlue = UIColor(red: 36/255, green: 60/255, blue: 112/255, alpha: 1)
    let themeYellow = UIColor(red: 227/255, green: 172/255, blue: 60/255, alpha: 1)
    let font:UIFont? = UIFont(name: "LXGWWenKai-Regular", size: CGFloat(20))
    
    let speaker = AVSpeechSynthesizer()
    

    let poemsDataSet = Poems.data
    var tenQuestionSelection = [Poems]()
    var index = 0
    
    
    @IBOutlet var practiceSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    @IBOutlet var choiceButtons: [UIButton]!
    @IBOutlet var functionButtons: [UIButton]!
    let functionButtonText = ["下一題  ▸","查看全詩  ▸","◂ 返回","再玩一次  ▸"]
    
    @IBOutlet var showFullPoemButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var playAgainButton: UIButton!
    
    
    @IBOutlet var correctnessLabel: UILabel!
    let correctnessSymbol = ["✓","✗"]
    
    @IBOutlet var testStatusView: UIView!
    @IBOutlet var testProgressView: UIProgressView!
    @IBOutlet var questionNumber: UILabel!
    
    @IBOutlet var testResultView: UIView!
    @IBOutlet var scoreLabel: UILabel!
    var score = 0
    
    
    
    //full poem
    @IBOutlet var fullPoemView: UIView!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var poetLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    
    
    @IBOutlet var cloudPattern: UIImageView!
    @IBOutlet var cloudPatternOnResult: UIImageView!
    @IBOutlet var cloudPatternOnFullPoem: UIImageView!
    
    //QA view
    
    @IBOutlet var questionAnswerView: UIView!
    
    
    
    
    fileprivate func setTheQuestion(dataSet: [Poems] ) {
        //問答
        questionLabel.text = dataSet[index].question
        answerLabel.text = dataSet[index].answer
        answerLabel.isHidden = true
        correctnessLabel.isHidden = true
        testResultView.isHidden = true
        showFullPoemButton.isHidden = true
        nextButton.isHidden = false
        playAgainButton.isHidden = true
        questionAnswerView.isHidden = true
        
        
        for buttons in choiceButtons {
            buttons.isEnabled = true
        }
        

            var semiAnswerSelection = dataSet
            semiAnswerSelection.remove(at: index)
            semiAnswerSelection.shuffle()
            var finalAnswerSelection = semiAnswerSelection.prefix(3)
            finalAnswerSelection.append(dataSet[index])
            finalAnswerSelection.shuffle()
        
        for (index, buttons) in choiceButtons.enumerated() {
            
            let attString:NSMutableAttributedString = NSMutableAttributedString(string: finalAnswerSelection[index].answer, attributes: [.font:font!])
            buttons.setAttributedTitle(attString, for: .normal)
        }
        
        //全詩
        titleTextView.text = dataSet[index].title
        poetLabel.text = dataSet[index].poet
        contentTextView.text = dataSet[index].content
        fullPoemView.isHidden = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //設置 segmented control 字型
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: themeBlue,
            .font: UIFont(name: "LXGWWenKai-Regular", size: 16)!
        ]
        practiceSegmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        
        testStatusView.isHidden = true
        
        
        index = Int.random(in: 0...poemsDataSet.count-1)
        setTheQuestion(dataSet: poemsDataSet)
       
   
            for (index, buttons) in functionButtons.enumerated() {

                let attString:NSMutableAttributedString = NSMutableAttributedString(string: functionButtonText[index], attributes: [.font:font!])
                buttons.setAttributedTitle(attString, for: .normal)
            }
            
        
        cloudPattern.alpha = 0.08
        cloudPatternOnResult.alpha = 0.08
        cloudPatternOnFullPoem.alpha = 0.08
        
    }

    
    
    fileprivate func testMode() {
        index = 0
        score = 0
        
        tenQuestionSelection = Array(poemsDataSet.shuffled().prefix(10))
        setTheQuestion(dataSet: tenQuestionSelection)
        
        testStatusView.isHidden = false
        testProgressView.progress = Float(index)/10.0
        questionNumber.text = "第 \(index+1) 題"
        
        
    }
    
    
    @IBAction func selectSegmentedControl(_ sender: Any) {
        if practiceSegmentedControl.selectedSegmentIndex == 0 {
            index = Int.random(in: 0...poemsDataSet.count-1)
            setTheQuestion(dataSet: poemsDataSet)
            
            testStatusView.isHidden = true
            questionAnswerView.isHidden = true
            
        } else if practiceSegmentedControl.selectedSegmentIndex == 1 {
            questionAnswerView.isHidden = true
            testMode()
    
        } else {
            
            index = Int.random(in: 0...poemsDataSet.count-1)
            setTheQuestion(dataSet: poemsDataSet)

            testStatusView.isHidden = true
            questionAnswerView.isHidden = false
        }
        
    }
    
    
    
    
    @IBAction func selectAnswer(_ sender: UIButton) {
        
        answerLabel.isHidden = false
        correctnessLabel.isHidden = false
        showFullPoemButton.isHidden = false
        
        let buttonX = sender.frame.origin.x
        let buttonY = sender.frame.origin.y

        correctnessLabel.frame = CGRect(x: buttonX+120, y: buttonY-35, width: 240, height: 130)
        
        if sender.titleLabel!.text == answerLabel.text {
            correctnessLabel.text = correctnessSymbol[0]
            score += 10
        } else {
            correctnessLabel.text = correctnessSymbol[1]
        }
        
        for buttons in choiceButtons {
            buttons.isEnabled = false
        }
        sender.isEnabled = true
        
    }
    
    
    
    
    @IBAction func showFullPoem(_ sender: UIButton) {
        fullPoemView.isHidden = false
        
    }
    
    @IBAction func hideFullPoem(_ sender: Any) {
        fullPoemView.isHidden = true
        speaker.stopSpeaking(at: .immediate)
        
    }
    
    
    @IBAction func goToNextQuestion(_ sender: UIButton) {
        
        if practiceSegmentedControl.selectedSegmentIndex == 0 {
            index = Int.random(in: 0...poemsDataSet.count-1)
            setTheQuestion(dataSet: poemsDataSet)
        } else if practiceSegmentedControl.selectedSegmentIndex == 1 {
            if index < 9 {
                
                index += 1
                setTheQuestion(dataSet: tenQuestionSelection)
                
                questionNumber.text = "第 \(index+1) 題"
                testProgressView.progress = Float(index)/10.0
                
                print(index, tenQuestionSelection[index].question)
                
            } else {
                //顯示測驗結果
                sender.isHidden = true
                showFullPoemButton.isHidden = true
                playAgainButton.isHidden = false
                testProgressView.progress = 1
                correctnessLabel.isHidden = true
                testResultView.isHidden = false
                scoreLabel.text = String(score)
                
            }
        } else if practiceSegmentedControl.selectedSegmentIndex == 2 {
            index = Int.random(in: 0...poemsDataSet.count-1)
            setTheQuestion(dataSet: poemsDataSet)
            questionAnswerView.isHidden = false
        }
    }
    
    
    @IBAction func playAgain(_ sender: UIButton) {
        sender.isHidden = true
        testMode()
    }
    
    
    @IBAction func showAnswer(_ sender: Any) {
        answerLabel.isHidden = false
        showFullPoemButton.isHidden = false
        correctnessLabel.isHidden = true
    }
    
    
    

    
    
    func reader (string: String) {
        
        let poemReader = AVSpeechUtterance(string: string)
         poemReader.voice = AVSpeechSynthesisVoice(language: "zh-TW")
        speaker.speak(poemReader)
    }
    
    @IBAction func readPoem(_ sender: Any) {
        
        reader(string: titleTextView.text!)
        reader(string: poetLabel.text!)
        reader(string: contentTextView.text)
    }
    
    
    
}
