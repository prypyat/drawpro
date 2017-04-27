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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        calculate()
    }
    
    
    
    @IBAction func calculate()
    {
        let t = pickerView.selectedRow(inComponent: 3)+1
        let n = pickerView.selectedRow(inComponent: 2)+1
        let r = pickerView.selectedRow(inComponent: 1)+1
        let p = pickerView.selectedRow(inComponent: 0)+1
        
        let test = Hypergeometric(numberOfTrials: n, requiredSuccesses: r, population: p)
        result.text = String(format: "%.4f", test.probability(of: t)*100)+"%"
    }
}

