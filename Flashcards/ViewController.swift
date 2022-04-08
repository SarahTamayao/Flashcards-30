//
//  ViewController.swift
//  Flashcards
//
//  Created by Peter Xiao on 2/26/22.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}
class ViewController: UIViewController {

    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var delButton: UIButton!
    @IBOutlet weak var card: UIView!
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        readSavedFlashcards()
        
        if flashcards.count==0{
            updateFlashcard(question: "What year did the US become independent?", answer: "1776")
        }
        else{
            updateLabels()
            updateButtons()
        }
    
    }
    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    func flipFlashcard(){
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight) {
            if self.frontLabel.isHidden == true{
                self.frontLabel.isHidden = false
            }
            else{
                self.frontLabel.isHidden = true
            }
        }

    }
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        
        updateLabels()
        
        updateButtons()
        
        animateCardOutNext()
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        
        updateLabels()
        
        updateButtons()
        
        animateCardOutPrev()
    }
    @IBAction func didTapOnDel(_ sender: Any) {
        flashcards.remove(at: currentIndex)
        if currentIndex == flashcards.count{ // the flashcard deleted was the last one
            currentIndex = currentIndex - 1
        }
        
        updateButtons()
        
        saveAllFlashcardsToDisk()
    }
    func animateCardOutNext(){
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        } completion: { finished in
            
            self.updateLabels()
            
            self.animateCardInNext()
        }

    }
    func animateCardInNext(){
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    func animateCardOutPrev(){
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        } completion: { finished in
            
            self.updateLabels()
            
            self.animateCardInPrev()
        }

    }
    func animateCardInPrev(){
        card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)

        flashcards.append(flashcard)
        
        print("New flashcard let's goo")
        print("There's now \(flashcards.count) flashcards let's goo")
        
        currentIndex = flashcards.count - 1
        print("The current index is \(currentIndex) let's goo")
        
        updateButtons()
        
        updateLabels()
        
        saveAllFlashcardsToDisk()
    }
    func updateButtons(){
        if currentIndex == flashcards.count - 1{
            nextButton.isEnabled = false
        }
        else {
            nextButton.isEnabled = true
        }
        if currentIndex == 0{
            prevButton.isEnabled = false
        }
        else {
            prevButton.isEnabled = true
        }
        if flashcards.count == 1{
            delButton.isEnabled = false
        }
        else{
            delButton.isEnabled = true
        }
    }
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    func saveAllFlashcardsToDisk(){
        
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question": card.question, "answer": card.answer]
        }
        UserDefaults.standard.set(dictionaryArray,forKey: "flashcards")
        print("Flashcards saved let's goo")
        
    }
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
    }
    

}

