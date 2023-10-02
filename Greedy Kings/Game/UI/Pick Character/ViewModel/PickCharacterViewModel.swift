//
//  PickPlayerViewModel.swift
//  Greedy Kings
//
//  Created by Garik Hovsepian on 27.09.23.
//

import Foundation

final class PickCharacterViewModel {
    var allPredefinedCharacters: [Character] = []
    private var firstPlayerCharacter: Character?
    private var secondPlayerCharacter: Character?
    private var characterAvatars = (1...6).map({ "character-\($0)" })
    
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
