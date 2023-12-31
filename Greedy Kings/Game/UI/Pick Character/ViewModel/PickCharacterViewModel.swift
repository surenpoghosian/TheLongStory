//
//  PickPlayerViewModel.swift
//  Greedy Kings
//
//  Created by Garik Hovsepyan on 27.09.23.
//

import Foundation
import UIKit

final class PickCharacterViewModel {
    var allPredefinedCharacters: [Character] = []
    let buttonImage = UIImage(named: "button")
    let buttonTouchedImage = UIImage(named: "buttonTouched")
    let backgroundColor = UIColor(red: 0.51, green: 0.40, blue: 0.33, alpha: 0.4)
    let cellBackground = UIImage(named: "cellFrame")
    let vsTitleImage = UIImage(named: "vsTitle")
    private var firstPlayerCharacter: Character?
    private var secondPlayerCharacter: Character?
    
    //check the pick character and change the state
    func selectCharacter(_ character: Character) {
        if firstPlayerCharacter == nil {
            firstPlayerCharacter = character
        } else if secondPlayerCharacter == nil {
            secondPlayerCharacter = character
        }
        
        if let index = allPredefinedCharacters.firstIndex(where: { $0.name == character.name }) {
            allPredefinedCharacters[index].availableToPick = false
        }
    }
}
