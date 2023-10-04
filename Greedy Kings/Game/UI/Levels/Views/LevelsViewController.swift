//
//  LevelsViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 24.09.23.
//

import UIKit

class LevelsViewController: UIViewController {
    private var levelsCollectionView: UICollectionView!
    private var pickLevelLabel: UILabel!
    private var viewModel: LevelsViewModel!
    
    var testData: [Character] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LevelsViewModel()
        setupLevelsCollectionView()
        
        testData = [Character(name: "Japan", avatar: UIImage(systemName: "photo.fill")!),
                    Character(name: "Egypt", avatar: UIImage(systemName: "photo.fill")!),
                    Character(name: "Armenia", avatar: UIImage(systemName: "photo.fill")!),
                    Character(name: "Mexico", avatar: UIImage(systemName: "photo.fill")!),
                    Character(name: "Italy", avatar: UIImage(systemName: "photo.fill")!),
                    Character(name: "Persia", avatar: UIImage(systemName: "photo.fill")!)]
        
    }
    
    
    private func setupPickLevelLabel() {
        pickLevelLabel = UILabel()
        pickLevelLabel.text = "Pick Level"
        view.addSubview(pickLevelLabel)
    }
    
    private func setupLevelsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let numberOfColumns: CGFloat = 3
        let numberOfRows: CGFloat = 2
        
        // Calculate the spacing between cells based on the screen size
        let cellSpacing: CGFloat = 10
        let totalSpacing = cellSpacing * (numberOfColumns - 1)
        
        let safeArea = view.safeAreaLayoutGuide
        let availableWidth = safeArea.layoutFrame.width - totalSpacing
        let availableHeight = safeArea.layoutFrame.height - cellSpacing * 2
        
        // Calculate the item size based on the available width and height while keeping items square
        let itemWidth = (availableWidth - totalSpacing) / numberOfColumns
        let itemHeight = (availableHeight - totalSpacing) / numberOfRows / 2
        
        print(itemWidth, itemHeight)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        
        // Calculate the section insets to center the cells horizontally
        let horizontalInset = (safeArea.layoutFrame.width - (itemWidth * numberOfColumns + totalSpacing)) / 2
        
        levelsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        levelsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelsCollectionView)
        
        NSLayoutConstraint.activate([
            levelsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: cellSpacing),
            levelsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: horizontalInset),
            levelsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -horizontalInset),
            levelsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -cellSpacing)
        ])
        
        levelsCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCell")
        
        levelsCollectionView.dataSource = self
        levelsCollectionView.delegate = self
    }
    
}

extension LevelsViewController: UICollectionViewDataSource {
    
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
        
        return cell
    }
}

extension LevelsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CharacterCollectionViewCell
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "GameSceneView") as? GameSceneViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }

        }
    }


extension LevelsViewController: UICollectionViewDelegateFlowLayout {
    
}

