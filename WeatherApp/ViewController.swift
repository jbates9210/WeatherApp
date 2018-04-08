//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jared Bates on 4/7/18.
//  Copyright © 2018 jared. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBAction func weatherButton(_ sender: Any) {
        // Create URL from weather-forecast.com using the inputed user text from cityTextField, omitting spaces for dashes
        if let url = URL(string: "https://www.weather-forecast.com/locations/" + cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            
            // If the cityTextField is blank, display a message to user
            if cityTextField.text == "" {
                resultLabel.text = "Please enter a valid city name. State names are not supported."
            } else {
                
                // create request using URL
                let request = NSMutableURLRequest(url: url)
                
                // create task with request
                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in
                    
                    //
                    var message = ""
                    
                    // if there is an error, print it
                    if let error = error {
                        print(error)
                    } else {
                        
                        // create variable for data that was gathered
                        if let unwrappedData = data {
                            
                            // create string of data from the unwrapped data or source code from above
                            let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                            
                            // separate out the START of the section of the website that is needed
                            var stringSeparator = "<p class=\"b-forecast__table-description-content\"><span class=\"phrase\">"
                            
                            // take dataString and separate the components by stringSeparator. First part of the content array will be all HTML code leading up to the end of the separater (position 0 in array), everything after is the rest of the HTML (position 1) which will include the description of weather that is needed.
                            if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                                
                                // If the array has content beyond position 0, then we have what we want from the previous separator
                                if contentArray.count > 1 {
                                    
                                    // create new separator to be the closed HTML tagof span
                                    stringSeparator = "</span>"
                                    
                                    // create new content array from position 1 of content array and split it's components by the new stringSeparator (</span>)
                                    let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                    
                                        // starting from position 1 in new array if it exists
                                        if newContentArray.count > 1 {
                                            
                                            // message variable will become the string needed, i.e. the weather description for the city
                                            message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                            print(newContentArray[0])
                                        }
                                }
                            }
                        }
                    }
                    
                    // if message contents is empty
                    if message == "" {
                        message = "The weather could not be found. Please check spelling and try again. Only city names are supported, not states."
                    }
                    
                    // Display contents of message to the resultLabel
                    DispatchQueue.main.sync(execute: {
                        self.resultLabel.text = message
                    })
                }
                task.resume()
            }
            
        } else {
            // if a valid city name was not entered, display error message in resultLabel.text
            resultLabel.text = "The weather could not be found. Please check spelling and try again. Only city names are supported, not states."
            
        }
    }
    
    // function to close keyboard on outside tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // close keyboard on return tap
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

