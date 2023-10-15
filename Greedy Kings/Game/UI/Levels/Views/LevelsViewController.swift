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
        setupUI()
        setupPickLevelLabel(hintText: "Pick the level")
        setupLevelsCollectionView()
        
        testData = [Character(name: "Japan", avatar: UIImage(named: "cellFrame")!, avatarID: "1"),
                    Character(name: "Egypt", avatar: UIImage(named: "cellFrame")!, avatarID: "2"),
                    Character(name: "Armenia", avatar: UIImage(named: "cellFrame")!, avatarID: "3")]
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    private func setupPickLevelLabel(hintText: String) {
        pickLevelLabel = UILabel()
        pickLevelLabel.text = hintText.uppercased()
        pickLevelLabel.font = UIFont(name: "Futura-Bold", size: 40.0)
        pickLevelLabel.alpha = 0.7
        pickLevelLabel.textAlignment = .center
        pickLevelLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickLevelLabel)
        
        NSLayoutConstraint.activate([
            pickLevelLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            pickLevelLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            pickLevelLabel.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func setupLevelsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let numberOfColumns: CGFloat = 3
        let numberOfRows: CGFloat = 1
        
        // Calculate the spacing between cells based on the screen size
        let cellSpacing: CGFloat = 1
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
        layout.sectionInset.top = 30
        
        // Calculate the section insets to center the cells horizontally
//        let horizontalInset = (safeArea.layoutFrame.width - (itemWidth * numberOfColumns + totalSpacing)) / 2
    
        levelsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        levelsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        levelsCollectionView.backgroundColor = .clear
        levelsCollectionView.layer.cornerRadius = 50
        view.addSubview(levelsCollectionView)
        
        NSLayoutConstraint.activate([
            levelsCollectionView.topAnchor.constraint(equalTo: pickLevelLabel.bottomAnchor, constant: 30),
            levelsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            levelsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            levelsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        levelsCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: "CharacterCell")
        levelsCollectionView.dataSource = self
        levelsCollectionView.delegate = self
    }
    
}

extension LevelsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return testData.count
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "GameSceneView") as? GameSceneViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }

        }
    }


extension LevelsViewController: UICollectionViewDelegateFlowLayout {
    
}

