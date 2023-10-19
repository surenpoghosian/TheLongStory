//
//  LevelsViewController.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 24.09.23.
//

import UIKit

class LevelsViewController: UIViewController {
    private var levelsCollectionView: UICollectionView!
    private var pickLevelLabel: UILabel!
    private var viewModel: LevelsViewModel!
    private var levelsData: [LevelsData]!
    @IBOutlet weak var backButton: UIButton!
    
    var pickedCharacters: PickedCharacters!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LevelsViewModel()
        setupUI()
        setupLevelsData()
        setupPickLevelLabel(hintText: "Pick the level")
        setupLevelsCollectionView()
        setupBackButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // setup UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.hidesBackButton = true
    }
    
    // setup levels data for UICollectionView
    private func setupLevelsData() {
        levelsData = [LevelsData(name: "Normal", iconID: "1", type: .normal),
                      LevelsData(name: "Halloween", iconID: "2", type: .halloween),
                      LevelsData(name: "Moon", iconID: "3", type: .moon)]
    }
    
    // setup custom navigation back button
    private func setupBackButton() {
        backButton.setBackgroundImage(UIImage(named: "leftArrowIcon"), for: .normal)
        backButton.addAction(UIAction(handler: {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }), for: .touchUpInside)
        self.view.bringSubviewToFront(backButton)
    }
    
    // setup header label
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
    
    // setup level picker UICollectionView
    private func setupLevelsCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let numberOfColumns: CGFloat = 3
        let cellSpacing: CGFloat = 10
        let safeArea = view.safeAreaLayoutGuide
        
        // calculate the item size
        let availableWidth = view.frame.width * 0.8
        let itemWidth = availableWidth / numberOfColumns - numberOfColumns * cellSpacing
        let itemHeight = itemWidth
        
        // setup layout settings
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        levelsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        levelsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(levelsCollectionView)
        
        NSLayoutConstraint.activate([
            levelsCollectionView.topAnchor.constraint(equalTo: pickLevelLabel.bottomAnchor, constant: 50),
            levelsCollectionView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            levelsCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8),
            levelsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -cellSpacing)
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
            vc.pickedCharacters = pickedCharacters
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

