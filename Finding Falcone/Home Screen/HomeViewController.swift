//
//  HomeViewController.swift
//  Finding Falcone
//
//  Created by Tushar on 09/09/23.
//

import Foundation

import UIKit

class HomeViewController: UIViewController {
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Finding Falcon"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        setupUI()
        startCountdown()
    }

    private func setupUI() {
        view.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func startCountdown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.transitionToListController()
        }
    }

    private func transitionToListController() {
        let listViewController = ListViewController(viewModel: ListViewModel(planetsData: viewModel.planetData ?? [], vehicleData: viewModel.vehicleData ?? []))
        let navController = UINavigationController(rootViewController: listViewController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
}

