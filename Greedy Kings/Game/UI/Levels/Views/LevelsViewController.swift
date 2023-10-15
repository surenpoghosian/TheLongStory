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
    private var levelsData: [LevelsData]!
    @IBOutlet weak var backButton: UIButton!
    
    var testData: [Character] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = LevelsViewModel()
        setupUI()
        setupPickLevelLabel(hintText: "Pick the level")
        setupLevelsCollectionView()
        setupBackButton()
        
        levelsData = [LevelsData(name: "Normal", iconID: "1", type: .normal),
                      LevelsData(name: "Halloween", iconID: "2", type: .halloween),
                      LevelsData(name: "Moon", iconID: "3", type: .moon)]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
        self.view.bringSubviewToFront(backButton)
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
            pickLevelLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 150),
            pickLevelLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -150)
        ])
    }
    
    private func setupLevelsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        // Set the section insets to center the cells horizontally.
        let cellSpacing: CGFloat = 1
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing

        let numberOfColumns: CGFloat = 3

        let totalSpacing = cellSpacing * (numberOfColumns - 1)
        let safeArea = view.safeAreaLayoutGuide
        let availableWidth = safeArea.layoutFrame.width - totalSpacing
        let itemWidth = (availableWidth / numberOfColumns).rounded(.down) // Use rounded(.down) to ensure integer values

        layout.itemSize = CGSize(width: itemWidth, height: itemWidth) // Square cells

        levelsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        levelsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelsCollectionView)

        NSLayoutConstraint.activate([
            levelsCollectionView.topAnchor.constraint(equalTo: pickLevelLabel.bottomAnchor, constant: 10),
            levelsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            levelsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            levelsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        levelsCollectionView.backgroundColor = .clear
        levelsCollectionView.register(LevelCollectionViewCell.self, forCellWithReuseIdentifier: "LevelCell")
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
        return levelsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelCell", for: indexPath) as! LevelCollectionViewCell
        let sectionOffset = indexPath.section * (levelsData.count / 2)
        let levelData = levelsData[sectionOffset + indexPath.row]
        cell.configure(with: levelData)
        
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

