//
//  ResultScreen.swift
//  Finding Falcone
//
//  Created by OLX on 06/09/23.
//

import UIKit

class ResultViewController: UIViewController {
    
    let resultLabel = UILabel()
    let startOverButton = UIButton()
    
    var viewModel: ResultViewModel
    
    init(viewModel: ResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        var fPlanetName = "No Planet Found"
        if let planetName = viewModel.result.planet_name {
            fPlanetName = "Planet found: \(planetName)"
        }
        resultLabel.text = fPlanetName
        resultLabel.font = .systemFont(ofSize: 24)
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        
        startOverButton.setTitle("Start Over", for: .normal)
        startOverButton.setTitleColor(.white, for: .normal)
        startOverButton.backgroundColor = .blue
        startOverButton.layer.cornerRadius = 10
        startOverButton.addTarget(self, action: #selector(startOver), for: .touchUpInside)
        
        view.addSubview(resultLabel)
        view.addSubview(startOverButton)
    }
    
    func setupConstraints() {
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        startOverButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            startOverButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startOverButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startOverButton.widthAnchor.constraint(equalToConstant: 200),
            startOverButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func startOver() {
        viewModel.startOver()
        self.navigationController?.popViewController(animated: true)
    }
}
