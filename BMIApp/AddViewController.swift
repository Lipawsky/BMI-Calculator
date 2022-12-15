//
//  ViewController.swift
//  BMIApp
//
//  Created by Pengfei Du on 2022-12-10.

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    var bmicalc = 0 //variable for bmi calculation in int
    var bmicorecalc = 0.0 //variable for bmi calculation in double
    @IBOutlet var items: [UITextField]!
    
    //outlets for the textlabels
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    @IBOutlet weak var unitSwitch: UISwitch!
    @IBOutlet weak var heightText: UITextView!
    @IBOutlet weak var weightText: UITextView!
    
    @IBOutlet weak var BMIValue: UITextField!
    
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!

    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func heightValueDidChange(_ sender: UISlider) { //when height slider changes
        
        let currentValue = Float(sender.value)
        if unitSwitch.isOn{
            heightText.text = "\(currentValue) inches"
        }
        else{
            heightText.text = "\(currentValue) centimetres"
        }
        self.calculateBMI()
    }
    

    
    
    @IBAction func weightValueDidChange(_ sender: UISlider) {  //when weight slider changes
        let currentValue = Float(sender.value)
        if unitSwitch.isOn{
            weightText.text = "\(currentValue) lbs"
        }
        else{
            weightText.text = "\(currentValue) kgs"
        }
        self.calculateBMI()
    }
    
    
    
    private func calculateBMI() {  //calculate BMI using the slider
        
        if unitSwitch.isOn{
            let htimp: Float = heightSlider.value
            let height = htimp/2.54
            let wtimp: Float = weightSlider.value
            let weight = wtimp*2.205
            let bmi: Float = (weight / (height*height))*703
            BMIValue.text = "\(bmi)"
            self.changeStatus(bmi: bmi)
            
            bmicalc = Int(Float(bmi))
        }
        else{
            let htcm: Float = heightSlider.value
            let height = htcm/100
            let weight: Float = weightSlider.value
            
            let bmi: Float = (weight / (height*height))
            BMIValue.text = "\(bmi)"
            self.changeStatus(bmi: bmi)
            bmicorecalc = Double(bmi)
            bmicalc = Int(Float(bmi))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let x = UserDefaults.standard.object(forKey: "myName") as? String
        {
            name.text = x
        }
        if let y = UserDefaults.standard.object(forKey: "myAge") as? String
        {
            age.text = y
        }
        if let z = UserDefaults.standard.object(forKey: "myGender") as? String
        {
            gender.text = z
        }
    }
    
    private func changeStatus(bmi: Float) {  //provide bmi message
        if (bmi < 16) {
            statusLabel.text = "Severe Thinness"
        } else if (bmi >= 16 && bmi < 17) {
            statusLabel.text = "Moderate Thinness"
        } else if (bmi >= 17 && bmi < 18.5) {
            statusLabel.text = "Mild Thinness"
        } else if (bmi >= 18.5 && bmi < 25) {
            statusLabel.text = "Normal"
        } else if (bmi >= 25 && bmi < 30) {
            statusLabel.text = "Overweight"
        } else if (bmi >= 30 && bmi < 35) {
            statusLabel.text = "Obese Class I"
        } else if (bmi >= 35 && bmi < 40) {
            statusLabel.text = "Obese Class II"
        }  else {
            statusLabel.text = "Obese Class III"
        }
    }
    
    
   
    
    @IBAction func reset(_ sender: UIButton) {
        items.forEach({$0.text=""})
        heightSlider.value = 0.5
        weightSlider.value = 0.5
        BMIValue.text = ""
        statusLabel.text = ""
        let namec = name.text!
        UserDefaults.standard.set(namec, forKey: "myName")
        let agec = age.text!
        UserDefaults.standard.set(agec, forKey: "myAge")
        let genderc = gender.text!
        UserDefaults.standard.set(genderc, forKey: "myGender")
        
    }
    
    @IBAction func AddRecord(_ sender: UIButton) {  //add to coredata
        let namec = name.text!
        UserDefaults.standard.set(namec, forKey: "myName")
        let agec = age.text!
        UserDefaults.standard.set(agec, forKey: "myAge")
        let genderc = gender.text!
        UserDefaults.standard.set(genderc, forKey: "myGender")
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        {
            let bmi = BMICoreData(entity: BMICoreData.entity(), insertInto: context)
            
            bmi.height = Double(heightSlider.value)
            bmi.weight = Double(weightSlider.value)
            bmi.bmival = Double(bmicorecalc)
    

            try? context.save()
        }
    }
    
    
}



