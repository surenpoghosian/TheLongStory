//
//  PlayerDataViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 24.09.23.
//

import UIKit

final class PlayerDataViewController: UIViewController {

    private var viewModel: GameSceneViewController!
    weak var delegate: GameDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = GameSceneViewController()
        // Do any additional setup after loading the view.
    }
}
