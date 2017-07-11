//
//  AboutViewController.swift
//  harmonia
//
//  Created by Jessee Zhang on 5/2/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import UIKit

protocol AboutViewControllerDelegate{
    
    var stylePicker: [String] { get }
    
    func getInitialStyle() -> Int
    func getInitialTempo() -> Int
    func getInitialBeatsPerMeasure() -> Double
    
    func setTempo(tempo:Int)
    func setBeatsPerMeasure(beatsPerMeasure:Double)
    func setStyleNumber(number:Int)
}

class AboutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var delegate:AboutViewControllerDelegate?
    var styleNumber = 0
    
    // Outlets
    @IBOutlet weak var stylePicker: UIPickerView!
    @IBOutlet weak var tempoDisplay: UILabel!
    @IBOutlet weak var tempoStepper: UIStepper!
    @IBOutlet weak var beatsPerMeasureDisplay: UILabel!
    @IBOutlet weak var beatsPerMeasureStepper: UIStepper!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "About"
        
        UIGraphicsBeginImageContext(self.view.bounds.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
        
        setInitialValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInitialValues(){
        stylePicker.selectRow(self.delegate!.getInitialStyle(), inComponent: 0, animated: false)
        
        let tempo = self.delegate!.getInitialTempo()
        tempoDisplay.text = String(tempo)
        tempoStepper.value = Double(tempo)
        
        let beatsPerMeasure = self.delegate!.getInitialBeatsPerMeasure()
        beatsPerMeasureDisplay.text = String(beatsPerMeasure)
        beatsPerMeasureStepper.value = beatsPerMeasure
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.delegate!.stylePicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.delegate!.stylePicker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate!.setStyleNumber(number: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let strTitle = self.delegate!.stylePicker[row]
        let attString = NSAttributedString(string: strTitle, attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attString
    }
    
    
    @IBAction func onTempoChange(_ sender: UIStepper) {
        let tempo = Int(sender.value)
        self.delegate!.setTempo(tempo: tempo)
        tempoDisplay.text = String(tempo)
    }
    
    
    @IBAction func onBeatsPerMeasureChange(_ sender: UIStepper) {
        let beatsPerMeasure = sender.value
        self.delegate!.setBeatsPerMeasure(beatsPerMeasure: beatsPerMeasure)
        beatsPerMeasureDisplay.text = String(beatsPerMeasure)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
