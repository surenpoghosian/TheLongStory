//
//  MainMenuViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 24.09.23.
//

import UIKit

final class MainMenuViewController: UIViewController {
    

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var soundMuteButton: UIButton!
    @IBOutlet weak var musicMuteButton: UIButton!
    
    
    private var viewModel: MainMenuViewModel!
    private var storageManager: StorageManager!
    
    var areHiddenButtonsOpen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainMenuViewModel()
        storageManager = StorageManager()
        setupUI()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForUnfinishedGame()
    }
    
    // Setting up animation of settings buttons
    private func toggleHiddenButtons() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            if self.areHiddenButtonsOpen {
                self.soundMuteButton.isHidden = true
                self.musicMuteButton.isHidden = true
                self.soundMuteButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.musicMuteButton.transform = CGAffineTransform(translationX: 0, y: 0)
            } else {
                self.soundMuteButton.isHidden = false
                self.musicMuteButton.isHidden = false
                self.soundMuteButton.transform = CGAffineTransform(translationX: -50, y: -50)
                self.musicMuteButton.transform = CGAffineTransform(translationX: 50, y: -50)
                self.soundMuteButton.alpha = 1
                self.musicMuteButton.alpha = 1
            }
            self.areHiddenButtonsOpen.toggle()
        }
    }
    
    //set view's background color and  buttons bg photos
    private func setupUI() {
        
        self.view.backgroundColor = viewModel.backgroundColor
        playButton.setBackgroundImage(viewModel.buttonImage, for: .normal)
        continueButton.setBackgroundImage(viewModel.buttonImage, for: .normal)
        settingsButton.setBackgroundImage(viewModel.settingsIcon, for: .normal)
        leaderboardButton.setBackgroundImage(viewModel.buttonImage, for: .normal)
        
        playButton.setBackgroundImage(viewModel.buttonTouchedImage, for: .highlighted)
        continueButton.setBackgroundImage(viewModel.buttonTouchedImage, for: .highlighted)
        settingsButton.setBackgroundImage(viewModel.settingsIconTouched, for: .highlighted)
        leaderboardButton.setBackgroundImage(viewModel.buttonTouchedImage, for: .highlighted)

        musicMuteButton.setBackgroundImage(viewModel.musicOnIcon, for: .normal)
        soundMuteButton.setBackgroundImage(viewModel.soundsOnIcon, for: .normal)
        
        soundMuteButton.alpha = 0
        musicMuteButton.alpha = 0
    }
    
    //set buttons UI and actions
    private func setupButtons() {
        
        soundMuteButton.isHidden = true
        musicMuteButton.isHidden = true
        soundMuteButton.transform = CGAffineTransform(translationX: 0, y: 0)
        musicMuteButton.transform = CGAffineTransform(translationX: 0, y: 0)
        
        continueButton.addAction(UIAction(handler: { [weak self]_ in
            
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "GameSceneView") as? GameSceneViewController {
            if let data = self?.storageManager.get(key: "game", storageType: .userdefaults) as? Data {
                let decoder = JSONDecoder()
                if let battleModel = try? decoder.decode(BattleModel.self, from: data) {
                    vc.battleModel = battleModel
                }
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }

            
        }), for: .touchUpInside)
        
        playButton.addAction(UIAction(handler: { [weak self]_ in
            self?.pushViewController(identifier: "PickCharacterView", viewControllerType: PickCharacterViewController.self)
        }), for: .touchUpInside)
        
        settingsButton.addAction(UIAction(handler: { [weak self]_ in
            self?.toggleHiddenButtons()
        }), for: .touchUpInside)
        
        leaderboardButton.addAction(UIAction(handler: { [weak self]_ in
            self?.pushViewController(identifier: "LeaderboardView", viewControllerType: LeaderboardViewController.self)
        }), for: .touchUpInside)
        
        musicMuteButton.addAction(UIAction(handler: {[weak self]_ in
            
        }), for: .touchUpInside)
        
        soundMuteButton.addAction(UIAction(handler: {[weak self]_ in
            
        }), for: .touchUpInside)
        
    }
    
    //push the given view controller
    private func pushViewController<T: UIViewController>(identifier: String, viewControllerType: T.Type) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func checkForUnfinishedGame(){
        let savedGameState = storageManager.get(key: "game", storageType: .userdefaults)
        if let _ = savedGameState {
            continueButton.isHidden = false
        } else {
            continueButton.isHidden = true
        }
    }
}

protocol GameDataDelegate: AnyObject {
    func didResultSent()
}

extension MainMenuViewModel: GameDataDelegate {
    func didResultSent() {
        print("Data Recieved!")
    }
}
