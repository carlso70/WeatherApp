//
//  ViewController.swift
//  Weather App
//
//  Created by Jimmy Carlson on 10/24/15.
//  Copyright © 2015 Jimmy Carlson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var result: UILabel!
    
    @IBAction func findWeather(sender: AnyObject) {
        
        var wasSuccessful = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if let url = attemptedUrl { //this avoids weird characters
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                if let urlContent = data {
                    
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    if websiteArray.count > 1 {
                        
                        let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                        
                        if weatherArray.count > 1 {
                            
                            wasSuccessful = true
                            
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º") //gets rid of the ugly html code for degrees
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.result.textColor = UIColor.blackColor()
                                self.result.text = weatherSummary
                                
                            })
                        }
                        
                    }
                    
                    if wasSuccessful == false {
                        
                        self.result.textColor = UIColor.redColor()
                        self.result.text = "Couldn't find the weather for that city - please try again. Maybe you spelled the city wrong?"
                        
                    }
                }
                
                
            }
             task.resume()
            
            
            
        } else {
            
            self.result.textColor = UIColor.redColor()
            self.result.text = "Couldn't find the weather for that city - please try again. Maybe you spelled the city wrong?"
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        cityTextField.resignFirstResponder()
        
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.cityTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

