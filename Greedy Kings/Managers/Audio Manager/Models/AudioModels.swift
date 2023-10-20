//
//  AudioModels.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 10.10.23.
//

import Foundation


enum AudioType {
    case background
    case hit
    case miss
    case menu
    case shot
    case finished
}


struct AudioSettings: Codable {
    var isMusicOn: Bool
    var areSoundsOn: Bool

}


enum AudioSettingType {
    case music
    case sounds
}
