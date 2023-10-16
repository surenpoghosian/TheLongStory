//
//  PickPlayerViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 27.09.23.
//

import UIKit

final class PickCharacterViewController: UIViewController {
    
    private var characterCollectionView: UICollectionView!
    private var player1Container: UIImageView!
    private var player2Container: UIImageView!
    private var pickedCharactersStackView: UIStackView!
    private var buttonsStackView: UIStackView!
    private var nextButton: UIButton!
    private var resetButton: UIButton!
    private var selectedPlayer: Int = 1
    private var pickedCharacterForPlayer1: Character?
    private var pickedCharacterForPlayer2: Character?
    private var viewModel: PickCharacterViewModel!
    @IBOutlet weak var backButton: UIButton!
    
    weak var delegate: GameDataDelegate?
    
    var characterData: [Character] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PickCharacterViewModel()
        setupUI()
        setupPickedCharactersStackView()
        setupButtonsStackView()
        setupPickCharacterCollectionView()
        setupBackButton()
        
        characterData = [Character(name: "Jobs", avatarID: "1"),
                         Character(name: "Jobs", avatarID: "2"),
                         Character(name: "Jobs", avatarID: "3"),
                         Character(name: "Jobs", avatarID: "4"),
                         Character(name: "Jobs", avatarID: "5"),
                         Character(name: "Jobs", avatarID: "6"),
                         Character(name: "Jobs", avatarID: "7"),
                         Character(name: "Jobs", avatarID: "8"),
                         Character(name: "Jobs", avatarID: "9"),
                         Character(name: "Jobs", avatarID: "10")]
        
    }
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.hidesBackButton = true
    }
    private func setupBackButton() {
        backButton.setBackgroundImage(UIImage(named: "leftArrowIcon"), for: .normal)
        backButton.addAction(UIAction(handler: {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        view.bringSubviewToFront(backButton)
    }
    
    private func setupPickedCharactersStackView() {
        player1Container = UIImageView(image: viewModel.cellBackground)
        player1Container.contentMode = .scaleAspectFit
        player2Container = UIImageView(image: viewModel.cellBackground)
        player2Container.contentMode = .scaleAspectFit
        
        
        pickedCharactersStackView = UIStackView(arrangedSubviews: [player1Container, player2Container])
        pickedCharactersStackView.axis = .horizontal
        pickedCharactersStackView.spacing = 10
        pickedCharactersStackView.distribution = .fillEqually
        pickedCharactersStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickedCharactersStackView)
        
        NSLayoutConstraint.activate([
            
            pickedCharactersStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            pickedCharactersStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            pickedCharactersStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            pickedCharactersStackView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 4)])
    }
    
    private func setupPickCharacterCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let numberOfColumns: CGFloat = 5
        let numberOfRows: CGFloat = 2
        
        // Calculate the spacing between cells based on the screen size
        let cellSpacing: CGFloat = 10
        let totalSpacing = cellSpacing * (numberOfColumns - 1)
        
        let safeArea = view.safeAreaLayoutGuide
        let availableWidth = safeArea.layoutFrame.width - totalSpacing * 2
        let availableHeight = safeArea.layoutFrame.height - pickedCharactersStackView.frame.height - buttonsStackView.frame.height - cellSpacing * 2
        
        // Calculate the item size based on the available width and height while keeping items square
        let itemWidth = (availableWidth - totalSpacing) / numberOfColumns / 2
        let itemHeight = (availableHeight - totalSpacing) / numberOfRows / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        
        // Center items horizontally
        layout.sectionInset = UIEdgeInsets(
            top: 10,
            left: (availableWidth - (numberOfColumns * itemWidth + (numberOfColumns - 1) * cellSpacing)) / 8,
            bottom: 0,
            right: (availableWidth - (numberOfColumns * itemWidth + (numberOfColumns - 1) * cellSpacing)) / 8
        )
        
        characterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        characterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        characterCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        view.addSubview(characterCollectionView)
        
        NSLayoutConstraint.activate([
            characterCollectionView.topAnchor.constraint(equalTo: pickedCharactersStackView.bottomAnchor, constant: 20),
            characterCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 140),
            characterCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -140),
            characterCollectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -cellSpacing)
        ])
        
        characterCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCell")
        
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
    }
    
    
    private func setupButtonsStackView() {
        
        nextButton = UIButton(type: .custom)
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 26.0)
        nextButton.frame = CGRect(x: 200, y: 200, width: 200, height: 50)
        nextButton.setBackgroundImage(viewModel.buttonImage, for: .normal)
        nextButton.setBackgroundImage(viewModel.buttonTouchedImage, for: .highlighted)
        nextButton.alpha = 0.5
        nextButton.addAction(UIAction(handler: {[weak self] _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "LevelsView") as? LevelsViewController {
                if self?.pickedCharacterForPlayer2 != nil {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }), for: .touchUpInside)
        
        resetButton = UIButton(type: .custom)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.black.withAlphaComponent(0.5), for: .normal)
        resetButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        resetButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 26.0)
        resetButton.setBackgroundImage(viewModel.buttonImage, for: .normal)
        resetButton.setBackgroundImage(viewModel.buttonTouchedImage, for: .highlighted)
        resetButton.addAction(UIAction(handler: {[weak self] _ in
            
            for subview in self?.player1Container.subviews ?? [] {
                subview.removeFromSuperview()
            }
            for subview in self?.player2Container.subviews ?? [] {
                subview.removeFromSuperview()
            }
            
            // Clear picked characters for both players
            self?.pickedCharacterForPlayer1 = nil
            self?.pickedCharacterForPlayer2 = nil
            
            // Enable all characters for picking again
            for index in 0..<(self?.characterData.count ?? 0) {
                self?.characterData[index].availableToPick = true
            }
            self?.selectedPlayer = 1
            self?.nextButton.alpha = 0.5
            // Reload the collection view to see changes
            self?.characterCollectionView.reloadData()
        }), for: .touchUpInside)
        
        buttonsStackView = UIStackView(arrangedSubviews: [resetButton, nextButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 50
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.heightAnchor.constraint(equalToConstant: view.frame.height / 11),
            buttonsStackView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
            buttonsStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 150),
            buttonsStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -150),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
}

extension PickCharacterViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let itemsPerSection = characterData.count / 2
        return section == 0 ? itemsPerSection : characterData.count - itemsPerSection
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCollectionViewCell
        let sectionOffset = indexPath.section * (characterData.count / 2)
        let character = characterData[sectionOffset + indexPath.row]
        
        // Call the configure function with the character data
        cell.configure(with: character)
        
        cell.isUserInteractionEnabled = character.availableToPick
        
        if character.availableToPick {
            cell.nameLabel.alpha = 1
            cell.isUserInteractionEnabled = true
        } else {
            cell.nameLabel.alpha = 0.7
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
}

extension PickCharacterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CharacterCollectionViewCell
        
        if cell != nil {
            let sectionOffset = indexPath.section * (characterData.count / 2)
            let selectedCharacter = characterData[sectionOffset + indexPath.row]
            
            // Check if the selected character is available to pick
            if selectedCharacter.availableToPick {
                if selectedPlayer == 1 {
                    if pickedCharacterForPlayer1 == nil {
                        // Create a new UIImageView for the picked character and add it as an overlay
                        let characterImageView = UIImageView(image: UIImage(named: selectedCharacter.avatarID))
                        characterImageView.contentMode = .scaleAspectFit
                        player1Container.addSubview(characterImageView)
                        
                        characterImageView.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            characterImageView.topAnchor.constraint(equalTo: player1Container.topAnchor, constant: 10),
                            characterImageView.leftAnchor.constraint(equalTo: player1Container.leftAnchor, constant: 10),
                            characterImageView.rightAnchor.constraint(equalTo: player1Container.rightAnchor, constant: -10),
                            characterImageView.bottomAnchor.constraint(equalTo: player1Container.bottomAnchor, constant: -10)])
                        
                        pickedCharacterForPlayer1 = selectedCharacter
                        characterData[sectionOffset + indexPath.row].availableToPick = false
                        if pickedCharacterForPlayer1 != nil {
                            selectedPlayer = 2
                        }
                    }
                } else if selectedPlayer == 2 {
                    if pickedCharacterForPlayer2 == nil {
                        // Create a new UIImageView for the picked character and add it as an overlay
                        let characterImageView = UIImageView(image: UIImage(named: selectedCharacter.avatarID))
                        characterImageView.contentMode = .scaleAspectFit
                        player2Container.addSubview(characterImageView)
                        
                        characterImageView.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            characterImageView.topAnchor.constraint(equalTo: player2Container.topAnchor, constant: 10),
                            characterImageView.leftAnchor.constraint(equalTo: player2Container.leftAnchor, constant: 10),
                            characterImageView.rightAnchor.constraint(equalTo: player2Container.rightAnchor, constant: -10),
                            characterImageView.bottomAnchor.constraint(equalTo: player2Container.bottomAnchor, constant: -10)])
                        
                        pickedCharacterForPlayer2 = selectedCharacter
                        nextButton.alpha = 1
                        characterData[sectionOffset + indexPath.row].availableToPick = false
                        selectedPlayer = 1
                    }
                }
                collectionView.reloadData()
            }
        }
    }
    
}


extension PickCharacterViewController: UICollectionViewDelegateFlowLayout {
    
}
