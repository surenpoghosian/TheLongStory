//
//  LeaderboardViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 24.09.23.
//

import UIKit

final class LeaderboardViewController: UIViewController {

    private var viewModel: LeaderboardViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LeaderboardViewModel()
        
    }
}
