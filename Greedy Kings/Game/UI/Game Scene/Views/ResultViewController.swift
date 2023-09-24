//
//  ResultViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 24.09.23.
//

import UIKit

final class ResultViewController: UIViewController {

    private var viewModel: GameSceneViewModel!
    weak var delegate: GameDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GameSceneViewModel()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didResultSent()
        
    }
}
