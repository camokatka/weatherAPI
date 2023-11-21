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
        lb.font = .boldSystemFont(ofSize: 24)
        return lb
    }()
    
    let cityTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "city"
        tf.textAlignment = .center
        tf.textColor = .black
        tf.font = .boldSystemFont(ofSize: 18)
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 12
        return tf
    }()
    
    let btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Get City", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 12
        btn.layer.borderWidth = 1
        btn.backgroundColor = .cyan
        return btn
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
    }

    private func initUI() {
        view.backgroundColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        view.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 30),
            btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btn.widthAnchor.constraint(equalToConstant: 90),
            btn.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        btn.addTarget(self, action: #selector(addCity), for: .touchUpInside)
        
        view.addSubview(cityTextField)
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: btn.bottomAnchor, constant: 30),
            cityTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityTextField.widthAnchor.constraint(equalToConstant: 200),
            cityTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        view.addSubview(tempLabel)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tempLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 70),
            tempLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)
        ])
        
        view.addSubview(windLabel)
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            windLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 70),
            windLabel.leadingAnchor.constraint(equalTo: tempLabel.trailingAnchor, constant: 30)
        ])
        
        view.addSubview(rainLabel)
        rainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rainLabel.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 70),
            rainLabel.leadingAnchor.constraint(equalTo: windLabel.trailingAnchor, constant: 30)
        ])
    }
    


    typealias City = [CityElement]
    
    @objc func addCity() {
        if let cityName = cityTextField.text {
            let url = URL(string: "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=5&appid=5e8ef26a7d652f29636a9ea8312242d5")
            let request = URLRequest(url: url!)
            
            let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
                guard let data else { return }
        
                let city = try? JSONDecoder().decode(City.self, from: data)
                
                getWeather(latitude: (city?[0].lat)!, longitude: (city?[0].lon)!)
            }

            task.resume()
        }
    }
    
    func getWeather(latitude: Double, longitude: Double) {
        let request = URLRequest(url: URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,rain,wind_speed_10m&timezone=Europe%2FMoscow&forecast_days=1")!)
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data else { return }
    
            let weather = try? JSONDecoder().decode(Weather.self, from: data)
            DispatchQueue.main.async { [self] in
                tempLabel.text! = "Temperature: \n \(weather!.current.temperature2M) \(weather!.currentUnits.temperature2M)"
                windLabel.text! = "Wind speed: \n \(weather!.current.windSpeed10M) \(weather!.currentUnits.windSpeed10M)"
                rainLabel.text! = "Rain: \n \(weather!.current.rain) \(weather!.currentUnits.rain)"
            }
            
        }

        task.resume()
    }
    

}

