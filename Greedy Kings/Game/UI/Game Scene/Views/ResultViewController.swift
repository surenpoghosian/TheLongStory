//
//  ResultViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 24.09.23.
//

import UIKit

final class ResultViewController: UIViewController {
    private var winnerLabel: UILabel!
    private var winnerImageView: UIImageView!
    private var winnerImage: UIImage!
    private var rematchButton: UIButton!
    private var mainMenuButton: UIButton!
    private var modal: UIView!
    private var buttonsStackView: UIStackView!
    private var modalStackView: UIStackView!
    weak var viewModel: GameSceneViewModel!
    var winner: Character!
    weak var delegate: GameDataDelegate?
    var onMainMenu: (()-> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupWinnerImage()
        setupWinnerLabel()
        setupButtonsStackView()
        setupModal()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.didResultSent()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.clear
    }
    
    private func setupWinnerImage() {
        winnerImage = UIImage(named: "\(winner.avatarID)")
        winnerImageView = UIImageView()
        winnerImageView.image = winnerImage
        winnerImageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            winnerImageView.widthAnchor.constraint(equalToConstant: CGFloat(100)),
            winnerImageView.heightAnchor.constraint(equalToConstant: CGFloat(100))
        ])
    }
    
    private func setupWinnerLabel() {
        winnerLabel = UILabel()
        winnerLabel.text = "\(winner.name) won!"
        winnerLabel.textAlignment = .center
        winnerLabel.font = UIFont(name: "Futura-Bold", size: 25.0)
        winnerLabel.textColor = .white
        winnerLabel.alpha = 0.7
    }
    
    private func setupButtonsStackView() {
        rematchButton = createButton(buttonLabel: "Rematch")
        rematchButton.addAction(UIAction(handler: {[weak self]_ in
            self?.viewModel.rematch()
            self?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        
        mainMenuButton = createButton(buttonLabel: "Main menu")
        mainMenuButton.addAction(UIAction(handler: {[weak self]_ in
            if let onMainMenu = self?.onMainMenu {
                self?.dismiss(animated: true)
                onMainMenu()
            }
        }), for: .touchUpInside)
        
        buttonsStackView = UIStackView(arrangedSubviews: [rematchButton, mainMenuButton])
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 15
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupModal() {
        modal = UIView()
        modal.layer.cornerRadius = 30
        modal.backgroundColor = UIColor(named: "backgroundColor")
        
        modalStackView = UIStackView(arrangedSubviews: [winnerImageView, winnerLabel, buttonsStackView])
        modalStackView.axis = .vertical
        modalStackView.spacing = 5
        modalStackView.distribution = .fillProportionally
        
        
        view.addSubview(modal)
        modal.addSubview(modalStackView)
        
        modalStackView.translatesAutoresizingMaskIntoConstraints = false
        modal.translatesAutoresizingMaskIntoConstraints = false
        winnerImageView.translatesAutoresizingMaskIntoConstraints = false
        winnerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modal.widthAnchor.constraint(equalToConstant: 300),
            modal.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            modalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalStackView.leftAnchor.constraint(equalTo: modal.leftAnchor, constant: 35),
            modalStackView.rightAnchor.constraint(equalTo: modal.rightAnchor, constant: -35),
            modalStackView.topAnchor.constraint(equalTo: modal.topAnchor, constant: 25),
            modalStackView.bottomAnchor.constraint(equalTo: modal.bottomAnchor, constant: -25)
            
        ])
    }
    
}


private func createButton(buttonLabel: String) -> UIButton {
    var button = UIButton()
    button = UIButton()
    button.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
    button.setTitle("\(buttonLabel)", for: .normal)
    button.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
    button.setBackgroundImage(UIImage(named: "button"), for: .normal)
    button.setBackgroundImage(UIImage(named: "buttonTouched"), for: .highlighted)
    button.titleLabel?.font = UIFont(name: "Futura-Bold", size: 16.0)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
        button.widthAnchor.constraint(equalToConstant: 100),
        button.heightAnchor.constraint(equalToConstant: 30)
    ])
    
    return button
}


