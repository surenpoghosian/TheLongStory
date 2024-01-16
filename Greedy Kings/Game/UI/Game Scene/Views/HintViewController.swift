//
//  HintView.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 16.01.24.
//

import UIKit


final class HintViewController: UIViewController {
    private var modal: UIView!
    private var modalStackView: UIStackView!

    private var hintImage: UIImage!
    private var hintImageView: UIImageView!
    private var okButton: UIButton!
    private var screenSize = UIScreen.main.bounds
    private var modalWidth: Double!
    private var modalHeight: Double!
    
    var onHintClose: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        
        modalWidth = screenSize.width * 0.7
        modalHeight = screenSize.height * 0.85
        setupHintImageView()
        setupOkButton()
        setupModal()
        setupModalStackView()
    }
    
    

    private func setupOkButton(){
        okButton = UIButton()
        okButton.setTitle("START", for: .normal)

        okButton.setBackgroundImage(UIImage(named: "button"), for: .normal)
        okButton.setBackgroundImage(UIImage(named: "buttonTouched"), for: .highlighted)
        
        okButton.setTitleColor(UIColor(named: "backgroundColor"), for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .bold)

        okButton.translatesAutoresizingMaskIntoConstraints = false

        okButton.addAction(UIAction(handler: {[weak self]_ in
            if let onHintClose = self?.onHintClose {
                self?.dismiss(animated: true)
                onHintClose()
            }
        }), for: .touchUpInside)
        
    }
    
    
    private func setupHintImageView(){
        hintImage = UIImage(named: "Gamescene_Hint")
        hintImageView = UIImageView()
        hintImageView.image = hintImage
        hintImageView.contentMode = .scaleAspectFit
        
        hintImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hintImageView.widthAnchor.constraint(equalToConstant: CGFloat(modalWidth * 0.9)),
            hintImageView.heightAnchor.constraint(equalToConstant: CGFloat(modalHeight * 0.75))
        ])
    }

    private func setupModal(){
        modal = UIView()
        modal.layer.cornerRadius = 30
        modal.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(modal)
        
        modal.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            modal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modal.widthAnchor.constraint(equalToConstant: modalWidth),
            modal.heightAnchor.constraint(equalToConstant: modalHeight)
        ])
    }
    
    private func setupModalStackView(){
        
        
        modalStackView = UIStackView(arrangedSubviews: [hintImageView, okButton])

        modalStackView.translatesAutoresizingMaskIntoConstraints = false

        modalStackView.axis = .vertical
        modalStackView.spacing = 10
        
        modal.addSubview(modalStackView)

        modalStackView.distribution = .fillProportionally
        
        NSLayoutConstraint.activate([
            modalStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalStackView.leftAnchor.constraint(equalTo: modal.leftAnchor, constant: 35),
            modalStackView.rightAnchor.constraint(equalTo: modal.rightAnchor, constant: -35),
            modalStackView.topAnchor.constraint(equalTo: modal.topAnchor, constant: 20),
            modalStackView.bottomAnchor.constraint(equalTo: modal.bottomAnchor, constant: -20),
            
        ])
    }
    
    

}

