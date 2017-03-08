//
//  ViewController.swift
//  Tip Calculator Prework
//
//  Created by Edem Attiogbe Cylindrical Mac Pro on 3/4/17.
//  Copyright © 2017 EndE Group. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipValue: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onTap(_ sender: Any) {
        
        view.endEditing(true);
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        
        let tipPercentages = [0.18, 0.2, 0.25];
        
        let bill: Double = Double(billField.text!) ?? 0.00;
        let tip: Double = bill * tipPercentages[tipControl.selectedSegmentIndex];
        let total: Double = bill + tip;

        tipValue.text = String(format: "$%.2f", tip);
        totalValue.text = String(format: "$%.2f", total);
        
        
    }
}
