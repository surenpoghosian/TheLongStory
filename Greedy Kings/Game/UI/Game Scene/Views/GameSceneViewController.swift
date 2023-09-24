//
//  GameSceneViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 24.09.23.
//

import UIKit

final class GameSceneViewController: UIViewController {

    private var viewModel: GameSceneViewController!
    weak var delegate: GameDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = GameSceneViewController()
        
    }
}