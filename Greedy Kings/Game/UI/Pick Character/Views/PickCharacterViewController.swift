//
//  PickPlayerViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 27.09.23.
//

import UIKit

final class PickCharacterViewController: UIViewController {
    private var characterCollectionView: UICollectionView!
    private var player1Container: UIImageView!
    private var player2Container: UIImageView!
    private var vsTitleImageView: UIImageView!
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
    
    //hide default navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PickCharacterViewModel()
        setupCharacterData()
        setupUI()
        setupPickedCharactersStackView()
        setupButtonsStackView()
        setupPickCharacterCollectionView()
        setupBackButton()
    }
    
    // setup view's UI, background color
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.hidesBackButton = true
    }
    
    // set character data
    private func setupCharacterData() {
        characterData = [Character(name: "Arthur", avatarID: "1"),
                         Character(name: "Richard", avatarID: "2"),
                         Character(name: "Henry", avatarID: "3"),
                         Character(name: "George", avatarID: "4"),
                         Character(name: "William", avatarID: "5"),
                         Character(name: "Edward", avatarID: "6"),
                         Character(name: "Charles", avatarID: "7"),
                         Character(name: "James", avatarID: "8"),
                         Character(name: "Louis", avatarID: "9"),
                         Character(name: "Alexander", avatarID: "10")]
    }
    
    // setup custom back button for navigation
    private func setupBackButton() {
        backButton.setBackgroundImage(UIImage(named: "leftArrowIcon"), for: .normal)
        backButton.addAction(UIAction(handler: {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        view.bringSubviewToFront(backButton)
    }
    
    // setup picked characters stack view
    private func setupPickedCharactersStackView() {
        player1Container = UIImageView(image: viewModel.cellBackground)
        player1Container.contentMode = .scaleAspectFit
        player2Container = UIImageView(image: viewModel.cellBackground)
        player2Container.contentMode = .scaleAspectFit
        vsTitleImageView = UIImageView(image: viewModel.vsTitleImage)
        vsTitleImageView.contentMode = .scaleAspectFit
        
        pickedCharactersStackView = UIStackView(arrangedSubviews: [player1Container,
                                                                   vsTitleImageView,
                                                                   player2Container])
        pickedCharactersStackView.axis = .horizontal
        pickedCharactersStackView.spacing = 10
        pickedCharactersStackView.distribution = .fillProportionally
        pickedCharactersStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickedCharactersStackView)
        
        NSLayoutConstraint.activate([
            
            pickedCharactersStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            pickedCharactersStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickedCharactersStackView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
            pickedCharactersStackView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 4),
            
            player1Container.widthAnchor.constraint(equalTo: vsTitleImageView.widthAnchor, multiplier: 2),
            player2Container.widthAnchor.constraint(equalTo: vsTitleImageView.widthAnchor, multiplier: 2),
            player1Container.heightAnchor.constraint(equalTo: player1Container.widthAnchor),
            player2Container.heightAnchor.constraint(equalTo: player2Container.widthAnchor),
            pickedCharactersStackView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 4)])
    }
    
    // setup character picker collection view
    private func setupPickCharacterCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        // calculate the size of cells
        let numberOfColumns: CGFloat = 5
        let cellSpacing: CGFloat = 10
        let safeArea = view.safeAreaLayoutGuide
        let availableWidth = view.frame.width * 0.6
        let itemWidth = availableWidth / numberOfColumns - 2 * numberOfColumns
        let itemHeight = itemWidth
        
        // set layout settings
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset.top = 15
        
        characterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        characterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        characterCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        view.addSubview(characterCollectionView)
        
        NSLayoutConstraint.activate([
            characterCollectionView.topAnchor.constraint(equalTo: pickedCharactersStackView.bottomAnchor, constant: cellSpacing),
            characterCollectionView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            characterCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.6),
            characterCollectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -cellSpacing)
        ])
        
        characterCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCell")
        
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
    }
    
    // setup "next" and "reset" buttons for character picker collection view
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
                if let character1 = self?.pickedCharacterForPlayer1, let character2 = self?.pickedCharacterForPlayer2 {
                    vc.pickedCharacters = PickedCharacters(player1Character: character1, player2Character: character2)
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
            
            // reset picked characters for both players
            self?.pickedCharacterForPlayer1 = nil
            self?.pickedCharacterForPlayer2 = nil
            
            // enable all characters for picking
            for index in 0..<(self?.characterData.count ?? 0) {
                self?.characterData[index].availableToPick = true
            }
            self?.selectedPlayer = 1
            self?.nextButton.alpha = 0.5
            
            // reload the collection view to see changes
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
        
        cell.configure(with: character)
        
        cell.isUserInteractionEnabled = character.availableToPick
        
        // check the availability of character for picking and change its ui state
        if character.availableToPick {
            cell.nameLabel.alpha = 1
            cell.characterImageView.alpha = 0.7
            cell.isUserInteractionEnabled = true
        } else {
            cell.nameLabel.alpha = 0.7
            cell.characterImageView.alpha = 0.7
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
            
            if selectedCharacter.availableToPick {
                if selectedPlayer == 1 {
                    if pickedCharacterForPlayer1 == nil {
                        
                        // create a new UIImageView for the picked character and add it as an overlay
                        let characterImageView = UIImageView(image: UIImage(named: selectedCharacter.avatarID))
                        characterImageView.contentMode = .scaleAspectFit
                        player1Container.addSubview(characterImageView)
                        
                        characterImageView.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            characterImageView.topAnchor.constraint(equalTo: player1Container.topAnchor, constant: 10),
                            characterImageView.leftAnchor.constraint(equalTo: player1Container.leftAnchor, constant: 10),
                            characterImageView.rightAnchor.constraint(equalTo: player1Container.rightAnchor, constant: -10),
                            characterImageView.bottomAnchor.constraint(equalTo: player1Container.bottomAnchor, constant: -10)
                        ])
                        
                        pickedCharacterForPlayer1 = selectedCharacter
                        
                        cell?.alpha = 0.5
                        
                        characterData[sectionOffset + indexPath.row].availableToPick = false
                        selectedPlayer = 2
                    }
                } else if selectedPlayer == 2 {
                    if pickedCharacterForPlayer2 == nil {
                        
                        // create a new UIImageView for the picked character and add it as an overlay
                        let characterImageView = UIImageView(image: UIImage(named: selectedCharacter.avatarID))
                        characterImageView.contentMode = .scaleAspectFit
                        player2Container.addSubview(characterImageView)
                        
                        characterImageView.translatesAutoresizingMaskIntoConstraints = false
                        
                        NSLayoutConstraint.activate([
                            characterImageView.topAnchor.constraint(equalTo: player2Container.topAnchor, constant: 10),
                            characterImageView.leftAnchor.constraint(equalTo: player2Container.leftAnchor, constant: 10),
                            characterImageView.rightAnchor.constraint(equalTo: player2Container.rightAnchor, constant: -10),
                            characterImageView.bottomAnchor.constraint(equalTo: player2Container.bottomAnchor, constant: -10)
                        ])
                        
                        pickedCharacterForPlayer2 = selectedCharacter
                        cell?.alpha = 0.5
                        characterData[sectionOffset + indexPath.row].availableToPick = false
                        nextButton.alpha = 1.0
                        selectedPlayer = 1
                    }
                }
                collectionView.reloadData()
            }
        }
    }
}
