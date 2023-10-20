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
    private var storageManager: StorageManager!
    private var isMusicOn: Bool!
    private var areSoundsOn: Bool!
    
    private var viewModel: MainMenuViewModel!
    
    var areHiddenButtonsOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        viewModel = MainMenuViewModel()
        storageManager = StorageManager()
        setupUI()
        setupButtons()
        storageManager = StorageManager()
        setupAudioSettings()
        checkAndSetupCharactersData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForUnfinishedGame()
    }
    
    func setupBackground(){
        let screenSize = UIScreen.main.bounds
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        imageview.contentMode = .scaleAspectFill
        let image = UIImage(named: "NormalScene1")

        if let blurredImage = image?.applyBlur(radius: 6.0) {
            imageview.image = blurredImage
            
        }
        
        
        self.view.insertSubview(imageview, at: 0)
    }
    
    private func checkAndSetupCharactersData(){
        if storageManager.get(key: "characters", storageType: .userdefaults) == nil {
            let characters = [Character(name: "Arthur", avatarID: "1"),
                              Character(name: "Richard", avatarID: "2"),
                              Character(name: "Henry", avatarID: "3"),
                              Character(name: "George", avatarID: "4"),
                              Character(name: "William", avatarID: "5"),
                              Character(name: "Edward", avatarID: "6"),
                              Character(name: "Charles", avatarID: "7"),
                              Character(name: "James", avatarID: "8"),
                              Character(name: "Louis", avatarID: "9"),
                              Character(name: "Alexander", avatarID: "10")]
            
            
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(characters) {
                storageManager.set(key: "characters", value: encodedData, storageType: .userdefaults)
            }
        }
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
    
    func removeSavedGame(){
        if let _ = self.storageManager.get(key: "game", storageType: .userdefaults) as? Data {
            storageManager.remove(key: "game", storageType: .userdefaults)
        }

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
                        self?.removeSavedGame()
                        vc.levelType = battleModel.levelType
                        vc.battleModel = battleModel
                    }
                }
                if self?.areHiddenButtonsOpen == true {
                    self?.toggleHiddenButtons()
                }
                
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }), for: .touchUpInside)
        
        playButton.addAction(UIAction(handler: { [weak self]_ in
            if self?.areHiddenButtonsOpen == true {
                self?.toggleHiddenButtons()
            }
            self?.pushViewController(identifier: "PickCharacterView", viewControllerType: PickCharacterViewController.self)
        }), for: .touchUpInside)
        
        settingsButton.addAction(UIAction(handler: { [weak self]_ in
            self?.toggleHiddenButtons()
        }), for: .touchUpInside)
        
        leaderboardButton.addAction(UIAction(handler: { [weak self]_ in
            self?.pushViewController(identifier: "LeaderboardView", viewControllerType: LeaderboardViewController.self)
        }), for: .touchUpInside)
        
        musicMuteButton.addAction(UIAction(handler: {[weak self]_ in
            if let isMusicOn = self?.isMusicOn {
                if isMusicOn{
                    self?.updateAudioSettings(type: .music, isOn: false)
                } else {
                    self?.updateAudioSettings(type: .music, isOn: true)
                }
                
            }
        }), for: .touchUpInside)
        
        soundMuteButton.addAction(UIAction(handler: {[weak self]_ in
            if let areSoundsOn = self?.areSoundsOn {
                if areSoundsOn {
                    self?.updateAudioSettings(type: .sounds, isOn: false)
                } else {
                    self?.updateAudioSettings(type: .sounds, isOn: true)
                }
                
            }
            
        }), for: .touchUpInside)
        
    }
    
    //push the given view controller
    private func pushViewController<T: UIViewController>(identifier: String, viewControllerType: T.Type) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? T {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    private func checkForUnfinishedGame(){
        let savedGameState = storageManager.get(key: "game", storageType: .userdefaults)
        if let _ = savedGameState {
            continueButton.isHidden = false
        } else {
            continueButton.isHidden = true
        }
    }
    
    
    private func setupAudioSettings(){
        if let data = storageManager.get(key: "audioSettings", storageType: .userdefaults) as? Data {
            let decoder = JSONDecoder()
            if let audioSettings = try? decoder.decode(AudioSettings.self, from: data) {
                print("saved audioSettings",audioSettings)
                isMusicOn = audioSettings.isMusicOn
                areSoundsOn = audioSettings.areSoundsOn
                updateAudioIcons()
            }
        } else {
            let audioSettings = AudioSettings(isMusicOn: true, areSoundsOn: true)
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(audioSettings) {
                storageManager.set(key: "audioSettings", value: encodedData, storageType: .userdefaults)
                isMusicOn = audioSettings.isMusicOn
                areSoundsOn = audioSettings.areSoundsOn
                updateAudioIcons()
            }
        }
    }
    
    func updateAudioIcons(){
        if isMusicOn {
            musicMuteButton.setBackgroundImage(viewModel.musicOnIcon, for: .normal)
        } else {
            musicMuteButton.setBackgroundImage(viewModel.musicOffIcon, for: .normal)
        }

        if areSoundsOn {
            soundMuteButton.setBackgroundImage(viewModel.soundsOnIcon, for: .normal)
        } else {
            soundMuteButton.setBackgroundImage(viewModel.soundsOffIcon, for: .normal)
            
        }
    }
    
    private func updateAudioSettings(type: AudioSettingType, isOn: Bool){
        if let data = storageManager.get(key: "audioSettings", storageType: .userdefaults) as? Data {
            let decoder = JSONDecoder()
            if let audioSettings = try? decoder.decode(AudioSettings.self, from: data) {
                var newAudioSettings: AudioSettings
                switch type {
                case .music:
                    newAudioSettings = AudioSettings(isMusicOn: isOn, areSoundsOn: audioSettings.areSoundsOn)
                    isMusicOn = isOn
                    areSoundsOn = audioSettings.areSoundsOn
                    updateAudioIcons()
                case .sounds:
                    newAudioSettings = AudioSettings(isMusicOn: audioSettings.isMusicOn, areSoundsOn: isOn)
                    isMusicOn = audioSettings.isMusicOn
                    areSoundsOn = isOn
                    updateAudioIcons()

                }
                
                let encoder = JSONEncoder()
                if let encodedData = try? encoder.encode(newAudioSettings) {
                    storageManager.set(key: "audioSettings", value: encodedData, storageType: .userdefaults)
                    
                }

            }
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
