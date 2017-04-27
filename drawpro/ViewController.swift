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
    
    
    let deck2 = Array(1...60)
    
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
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (n > p)
        {
            let alert = UIAlertController(title: "Error",
                                          message: "Number of cards to draw larger than total number of cards in deck",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (t > n)
        {
            let alert = UIAlertController(title: "Error",
                                          message: "Number of target cards in draw larger than total number of cards in draw",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let test = Hypergeometric(numberOfTrials: n, requiredSuccesses: r, population: p)
            result.text = String(format: "%.02f", test.probability(of: t)*100)+"%"
            atleast.text = String(format: "%.02f", 100-(test.distribution(.less(t))*100))+"%"
            rText.text = "Chance of exactly \(t) draws"
            lText.text = "Chance of at least \(t) draws"

        }
    }
}

