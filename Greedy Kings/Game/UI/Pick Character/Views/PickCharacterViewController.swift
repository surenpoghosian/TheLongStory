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
    
    weak var delegate: GameDataDelegate?
    
    var testData: [Character] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPickedCharactersStackView()
        setupButtonsStackView()
        setupPickCharacterCollectionView()
        
        testData = [Character(name: "Jobs", avatar: UIImage(systemName: "trash.fill")!),
                    Character(name: "Woz", avatar: UIImage(systemName: "seal.fill")!),
                    Character(name: "Jony", avatar: UIImage(systemName: "eye.fill")!),
                    Character(name: "Gates", avatar: UIImage(systemName: "exclamationmark.shield.fill")!),
                    Character(name: "Zuck", avatar: UIImage(systemName: "sunset.circle.fill")!),
                    Character(name: "Musk", avatar: UIImage(systemName: "globe.asia.australia.fill")!)]
        
        viewModel = PickCharacterViewModel()
    }
    
    private func setupPickedCharactersStackView() {
        player1Container = UIImageView(image: UIImage(systemName: "person.fill"))
        player1Container.contentMode = .scaleAspectFit
        player2Container = UIImageView(image: UIImage(systemName: "person.fill"))
        player2Container.contentMode = .scaleAspectFit
        
        
        pickedCharactersStackView = UIStackView(arrangedSubviews: [player1Container, player2Container])
        pickedCharactersStackView.axis = .horizontal
        pickedCharactersStackView.spacing = 10
        pickedCharactersStackView.distribution = .fillEqually
        pickedCharactersStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickedCharactersStackView)
        
        NSLayoutConstraint.activate([
            
            pickedCharactersStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            pickedCharactersStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            pickedCharactersStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            pickedCharactersStackView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height / 4)])
    }
    
    private func setupPickCharacterCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let numberOfColumns: CGFloat = 3
        let numberOfRows: CGFloat = 2
        
        // Calculate the spacing between cells based on the screen size
        let cellSpacing: CGFloat = 10
        let totalSpacing = cellSpacing * (numberOfColumns - 1)
        
        let safeArea = view.safeAreaLayoutGuide
        let availableWidth = safeArea.layoutFrame.width - totalSpacing
        let availableHeight = safeArea.layoutFrame.height - pickedCharactersStackView.frame.height - buttonsStackView.frame.height - cellSpacing * 2
        
        // Calculate the item size based on the available width and height while keeping items square
        let itemWidth = (availableWidth - totalSpacing) / numberOfColumns
        let itemHeight = (availableHeight - totalSpacing) / numberOfRows / 2
        
        print(itemWidth, itemHeight)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        
        // Calculate the section insets to center the cells horizontally
        let horizontalInset = (safeArea.layoutFrame.width - (itemWidth * numberOfColumns + totalSpacing)) / 2
        
        
        characterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        characterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(characterCollectionView)
        
        NSLayoutConstraint.activate([
            characterCollectionView.topAnchor.constraint(equalTo: pickedCharactersStackView.bottomAnchor, constant: cellSpacing),
            characterCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalInset),
            characterCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -horizontalInset),
            characterCollectionView.bottomAnchor.constraint(equalTo: buttonsStackView.topAnchor, constant: -cellSpacing)
        ])
        
        characterCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCell")
        
        characterCollectionView.dataSource = self
        characterCollectionView.delegate = self
    }
    
    private func setupButtonsStackView() {
        
        nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.tintColor = .white
        nextButton.frame = CGRect(x: 200, y: 200, width: 200, height: 50)
        nextButton.addAction(UIAction(handler: {[weak self] _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "LevelsView") as? LevelsViewController {
                if self?.pickedCharacterForPlayer2 != nil {
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }), for: .touchUpInside)
        
        resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = .systemBlue
        resetButton.tintColor = .white
        resetButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        resetButton.addAction(UIAction(handler: {[weak self] _ in
            
            // Reset the player containers to default images
            self?.player1Container.image = UIImage(systemName: "person.fill")
            self?.player2Container.image = UIImage(systemName: "person.fill")
            
            // Clear picked characters for both players
            self?.pickedCharacterForPlayer1 = nil
            self?.pickedCharacterForPlayer2 = nil
            
            // Enable all characters for picking again
            for index in 0..<(self?.testData.count ?? 0) {
                self?.testData[index].availableToPick = true
            }
            
            // Reload the collection view to reflect the changes
            self?.characterCollectionView.reloadData()
        }), for: .touchUpInside)
        
        buttonsStackView = UIStackView(arrangedSubviews: [nextButton, resetButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 10
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)
        
        NSLayoutConstraint.activate([
            buttonsStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 5),
            buttonsStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -5),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
}

extension PickCharacterViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        let itemsPerSection = testData.count / 2
        return section == 0 ? itemsPerSection : testData.count - itemsPerSection
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCollectionViewCell
        let sectionOffset = indexPath.section * (testData.count / 2)
        let character = testData[sectionOffset + indexPath.row]
        cell.configure(with: character)
        cell.isUserInteractionEnabled = character.availableToPick
        
        if character.availableToPick {
                // Character is available, set the default cell appearance
                cell.backgroundColor = .white
                cell.isUserInteractionEnabled = true
            } else {
                // Character is unavailable, customize the appearance
                cell.backgroundColor = .gray // Set the background color to gray
                cell.isUserInteractionEnabled = false // Disable user interaction
            }
        return cell
    }
}

extension PickCharacterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CharacterCollectionViewCell
        
        if cell != nil {
            let sectionOffset = indexPath.section * (testData.count / 2)
            let selectedCharacter = testData[sectionOffset + indexPath.row]

            // Check if the selected character is available to pick
            if selectedCharacter.availableToPick {
                if selectedPlayer == 1 {
                    if pickedCharacterForPlayer1 == nil {
                        player1Container.image = selectedCharacter.avatar
                        pickedCharacterForPlayer1 = selectedCharacter
                        testData[sectionOffset + indexPath.row].availableToPick = false
                        selectedPlayer = 2
                    }
                } else if selectedPlayer == 2 {
                    if pickedCharacterForPlayer2 == nil {
                        player2Container.image = selectedCharacter.avatar
                        pickedCharacterForPlayer2 = selectedCharacter
                        testData[sectionOffset + indexPath.row].availableToPick = false
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
