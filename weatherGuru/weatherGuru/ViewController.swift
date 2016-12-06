//
//  ViewController.swift
//  weatherGuru
//
//  Created by Yadel Abraham on 12/4/16.
//  Copyright © 2016 Yadel. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var cityTextField: UITextField!

    @IBOutlet var resultsLabel: UILabel!
    
    //TODO:for now I am only getting the weather not yet activites
    //Aldo, and I will figure that part.
    //Very hard coded
    
    //
    
   var categorizedOutput: [String: String] = [
        "weather": "not known",
        "temp": "0",
        "wind": "0.0"
    ]
    
    var weather: String = ""
    var temp: Int = 0
    var windSpeed: Double = 0.0
    
    var weatherSummary: String = ""
    
    //I created this method to extract the crucial information from the forecast in order to turn it into the prediction for the activity. Still needs a little bit of work.
    func analyzeWeather() {
        //Analyzes weather, temperature and wind
        //Reference: http://stackoverflow.com/questions/27880650/swift-extract-regex-matches
        
        //Set weather variable for recommendation
        let weather = categorizedOutput["weather"]!
        let temp = categorizedOutput["temp"]!
        let wind = categorizedOutput["wind"]!
        if (weather.contains("rain") || weather.contains("Rain")) {
            self.weather = "rain"
        }
        
        //Set temperature variable for recommendation
        //let regex = try! NSRegularExpression(pattern: "/([\s\S]\d\d)/")
        let regex = try! NSRegularExpression(pattern: "[0-9][0-9]|[0-9]");
        let nsString = temp as NSString
        let results = regex.matches(in: temp, range: NSRange(location: 0, length: nsString.length))
        let matches = results.map { nsString.substring(with: $0.range)}
        self.temp = Int(matches[0])!
        //print(matches)
        //var matches = regex.matches(in: temp, range: NSRange(location: 0, length: temp.characters.count))
        //print(temp)
        
        
        //Set windSpeed variable for recommendation, only really used to make sure not to recommend anything during a hurricane or tornado
        //Note: give lower priority
        //let nsString_wind = temp as NSString
        //let results_wind = regex.matches(in: wind, range: NSRange(location: 0, length: nsString_wind.length))
        //let matches_wind = results_wind.map { nsString_wind.substring(with: $0.range)}
        //self.windSpeed = Double(matches_wind[0])!
        
        print(self.temp)
        //print(self.windSpeed)
    }
    
    @IBAction func findWeather(_ sender: AnyObject) {
        var wasSuccessful = false
        //Go to this url and fetch weather for the city entered.
        let attemptedurl = URL(string: "http://www.weather-forecast.com/locations/"+cityTextField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest")
        if let url = attemptedurl {
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                
                if let urlContent = data {
                    let webcontent = NSString(data: urlContent, encoding: String.Encoding.utf8.rawValue)
                    let websiteArray = webcontent?.components(separatedBy: "3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    if (websiteArray?.count)! > 1 {
                        let weatherArray = websiteArray![1].components(separatedBy: "</span>")
                        if weatherArray.count > 1 {
                            wasSuccessful = true
                            self.weatherSummary = weatherArray[0].replacingOccurrences(of: "&deg;", with: "º")
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.resultsLabel.text = self.weatherSummary
                            })
                        }
                        
                        //Yadel: I added a few things here as well as made weatherSummary a global variable.
                        //The basic idea is the following: resultsLabel is essentially a paragraph with 3 sentences. The first sentence contains information on precipitation (i.e., raining, drizzling, sunny, cloudy, etc.). The second sentence has temperature, and the third is wind speed. We probably won't really need the last one so let's prioritize on the other 2. I have thus split weatherSummary into 3 sentences that we will then analyze in the method "analyzeWeather"
                        let splitWeatherArray = self.weatherSummary.components(separatedBy: ".")
                        self.categorizedOutput["weather"] = splitWeatherArray[0]
                        self.categorizedOutput["temp"] = splitWeatherArray[1]
                        self.categorizedOutput["wind"] = splitWeatherArray[2]
                        self.analyzeWeather()
                    }
                    
                    if wasSuccessful == false {
                        self.resultsLabel.text = "Couldn't find weather for that city. Please, check your spelling and try again!"
                    }
                }
            })
            task.resume()
        } else {
            self.resultsLabel.text = "Couldn't find weather for that city. Please, check your spelling and  try again!"
            
        }
    }
    
    //Gets us the user location in lat and longitudes for now
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //it just prints users location for now.
        print(locations)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

