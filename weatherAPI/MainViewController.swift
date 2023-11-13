//
//  ViewController.swift
//  weatherAPI
//
//  Created by Elizabeth Serykh on 09.11.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    let welcomeLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Welcome to Wheather APP"
        lb.textColor = .black
        return lb
    }()
    
    let cityLabel: UILabel = {
        let lb = UILabel()
        lb.text = "City: \n Belgorod"
        lb.lineBreakMode = .byWordWrapping
        lb.numberOfLines = 2
        lb.textAlignment = .center
        lb.textColor = .systemCyan
        lb.font = .boldSystemFont(ofSize: 30)
        return lb
    }()
    
    let tempLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Temperature: "
        lb.lineBreakMode = .byWordWrapping
        lb.numberOfLines = 2
        lb.textAlignment = .center
        lb.textColor = .black
        return lb
    }()
    
    let windLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Wind speed: "
        lb.lineBreakMode = .byWordWrapping
        lb.numberOfLines = 2
        lb.textAlignment = .center
        lb.textColor = .black
        return lb
    }()
    
    let rainLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Rain: "
        lb.lineBreakMode = .byWordWrapping
        lb.numberOfLines = 2
        lb.textAlignment = .center
        lb.textColor = .black
        return lb
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        var dataD = Data()
        let request = URLRequest(url: URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m,rain,wind_speed_10m&timezone=Europe%2FMoscow&forecast_days=1")!)
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if let data = data {
                dataD = data }
    
            let weather = try? JSONDecoder().decode(Weather.self, from: dataD)
            DispatchQueue.main.async { [self] in
                tempLabel.text! += "\n \(weather!.current.temperature2M) \(weather!.currentUnits.temperature2M)"
                windLabel.text! += "\n \(weather!.current.windSpeed10M) \(weather!.currentUnits.windSpeed10M)"
                rainLabel.text! += "\n \(weather!.current.rain) \(weather!.currentUnits.rain)"
            }
            
        }

        task.resume()
        
        
    }

    private func initUI() {
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(cityLabel)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 70),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(tempLabel)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 70),
            tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        view.addSubview(windLabel)
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            windLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 70),
            windLabel.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: 30)
        ])
        
        view.addSubview(rainLabel)
        rainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rainLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 70),
            rainLabel.leadingAnchor.constraint(equalTo: windLabel.trailingAnchor, constant: 30)
        ])
    }
    

}

