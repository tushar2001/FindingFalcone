//
//  HomeViewController.swift
//  Finding Falcone
//
//  Created by Tushar on 09/09/23.
//

import Foundation

import UIKit

class HomeViewController: UIViewController {
    // label for App Name on launch or home screen
    private let titleLabel: UILabel = {
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

    // MARK: Set up the UI elements and their constraints
    private func setupUI() {
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    
    // MARK: Start countdown to transition to the list controller
    private func startCountdown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.transitionToListController()
        }
    }

    // Present ListController
    private func transitionToListController() {
        let listViewModel = ListViewModel(planetsData: viewModel.planetData ?? [], vehicleData: viewModel.vehicleData ?? [])
        let listViewController = ListViewController(viewModel: listViewModel)
        let navController = UINavigationController(rootViewController: listViewController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
}

