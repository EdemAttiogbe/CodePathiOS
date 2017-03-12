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
    
    @IBOutlet weak var dollarSignOne: UIImageView!
    @IBOutlet weak var dollarSignTwo: UIImageView!
    @IBOutlet weak var dollarSignThree: UIImageView!
    
    
    let dataLayer: TipPercentageDataModelSingleton = TipPercentageDataModelSingleton.tipPercentageSharedDataModel;//The data layer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //---------------------------------------------------------------------------------------------------------------------------------------
        //Setup
        let tipPercentageKeys: [String] = Array(dataLayer.tipPercentData.tipDict.keys);
        self.tipControl.removeAllSegments();
        
        var segmentCounter = 0;
        for tip in tipPercentageKeys{
            self.tipControl.insertSegment(withTitle: tip, at: segmentCounter, animated: true);
            segmentCounter += 1;
        }
        print("Main View: Added all Tip Percentages from data model: \(tipPercentageKeys)");
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Select the default tip percentage automatically
        for segment in 0 ..< self.tipControl.numberOfSegments{
            let segTitle: String = self.tipControl.titleForSegment(at: segment)!;
            if (dataLayer.tipPercentData.defaultTipPercentage == segTitle){ self.tipControl.selectedSegmentIndex = segment; }
        }
        print("Main View: Found and set the default Tip Percentage in the Segmented Control: \(self.tipControl.titleForSegment(at: self.tipControl.selectedSegmentIndex)!)");
        
        self.calculateTipHelper();//Calculate the tip automatically, based on what is selected
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onTap(_ sender: Any) {
        
        view.endEditing(true);
    }
    
    @IBAction func calculateTip(_ sender: AnyObject) {
        
        self.calculateTipHelper();
    }
    
    func calculateTipHelper(){
        
        let bill: Double = Double(billField.text!) ?? 0.00;
        let tip: Double = bill * dataLayer.tipPercentData.tipDict[self.tipControl.titleForSegment(at: self.tipControl.selectedSegmentIndex)!]!;
        print("Main View: Computed bill amount: \(bill)");
        let total: Double = bill + tip;
        print("Main View: Computed total amount: \(total)");
        tipValue.text = String(format: "$%.2f", tip);
        totalValue.text = String(format: "$%.2f", total);
    }
}
