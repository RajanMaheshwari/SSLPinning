//
//  ViewController.swift
//  SSLPinningDemo
//
//  Created by Rajan Maheshwari on 10/10/22.
//

import UIKit

struct WeatherResponse: Decodable {
    
    var main: Main
    
    struct Main: Decodable {
        var tempMin: Double
        var tempMax: Double
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherData()
    }
    
    fileprivate func getWeatherData() {
        // Do any additional setup after loading the view.
        
        var url = URL.init(string: "https://api.openweathermap.org/data/2.5/weather")
        
        let queryItems = [
            URLQueryItem.init(name: "lat", value: "28.7041"),
            URLQueryItem.init(name: "lon", value: "77.1025"),
            URLQueryItem.init(name: "units", value: "metric"),
            URLQueryItem.init(name: "appid", value: "26f1ffa29736dc1105d00b93743954d2"),
        ]
        
        if #available(iOS 16.0, *) {
            url?.append(queryItems: queryItems)
        } else {
            // Fallback on earlier versions
            var components = URLComponents.init(url: url!, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            url = components?.url
        }
        
        NetworkManager.shared.afRequest(url: url, expecting: WeatherResponse.self) { [weak self] data, error in
            
            if let error {
                let alert = UIAlertController.init(title: error.localizedDescription, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "Ok", style: .cancel))
                DispatchQueue.main.async {
                    self?.present(alert, animated: true)
                }
                print(error.localizedDescription)
                return
            }
            
            if let data {
                DispatchQueue.main.async {
                    self?.minTempLabel.text = "\(data.main.tempMin)"
                    self?.maxTempLabel.text = "\(data.main.tempMax)"
                }
            }
        }
    }


}

