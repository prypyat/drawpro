//
//  ViewController.swift
//  drawpro
//
//  Created by 20056142 on 21/04/2017.
//  Copyright © 2017 20056142. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var atleast: UILabel!
    @IBOutlet weak var rText: UILabel!
    @IBOutlet weak var lText: UILabel!
    
    @IBOutlet weak var totaldeck: UIButton!
    @IBOutlet weak var targetdeck: UIButton!
    @IBOutlet weak var totaldraw: UIButton!
    @IBOutlet weak var targetdraw: UIButton!
    
    @IBOutlet weak var totaldeckText: UILabel!
    @IBOutlet weak var targetdeckText: UILabel!
    @IBOutlet weak var totaldrawText: UILabel!
    @IBOutlet weak var targetdrawText: UILabel!
    
    let deck2 = Array(1...60)
    
    var labels = true;
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return String(deck2[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return deck2.count
    }
    
    @IBAction func calculate(_ sender: UIButton)
    {
        let t = pickerView.selectedRow(inComponent: 3)+1
        let n = pickerView.selectedRow(inComponent: 2)+1
        let r = pickerView.selectedRow(inComponent: 1)+1
        let p = pickerView.selectedRow(inComponent: 0)+1
        
        if (r > p)
        {
            let alert = UIAlertController(title: "Error",
                                          message: "Number of target cards larger than total number of cards in deck",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (n > p)
        {
            let alert = UIAlertController(title: "Error",
                                          message: "Number of cards to draw larger than total number of cards in deck",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (t > n)
        {
            let alert = UIAlertController(title: "Error",
                                          message: "Number of target cards in draw larger than total number of cards in draw",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let test = Hypergeometric(numberOfTrials: n, requiredSuccesses: r, population: p)
            result.text = String(format: "%.02f", test.probability(of: t)*100)+"%"
            atleast.text = String(format: "%.02f", 100-(test.distribution(.less(t))*100))+"%"
            rText.text = "Chance of exactly \(t) draw(s)"
            lText.text = "Chance of at least \(t) draw(s)"
        }
    }
    
    @IBAction func howTo(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "How to Use", message: "Welcome to DeckPro, Deck probability calculator.\n \n Use the picker to insert variables, and click the button to calculate the chances of drawing specific cards. \n \n The first column on the left is for setting the current number of cards in the deck, next row is how many target cards are still in the deck, third row is how many cards to draw next turn, and the last row is how many of the target card you want or need.\n \n Use the switch on the top left to switch between labels and icons for row descriptions. \n \n Probably library used for Hypergeometric calculations. Probably is created by Harlan Haskins. \n https://github.com/harlanhaskins/Probably",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func switchView(_ sender: Any)
    {
        if (labels)
        {
            totaldeckText.isHidden = true
            targetdeckText.isHidden = true
            totaldrawText.isHidden = true
            targetdrawText.isHidden = true
            
            totaldeck.isHidden = false
            targetdeck.isHidden = false
            totaldraw.isHidden = false
            targetdraw.isHidden = false
            
            labels = false
        }
        else
        {
            totaldeckText.isHidden = false
            targetdeckText.isHidden = false
            totaldrawText.isHidden = false
            targetdrawText.isHidden = false
            
            totaldeck.isHidden = true
            targetdeck.isHidden = true
            totaldraw.isHidden = true
            targetdraw.isHidden = true
            
            labels = true
        }
    }
    
}

