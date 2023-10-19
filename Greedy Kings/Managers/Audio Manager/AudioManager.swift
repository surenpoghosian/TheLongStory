//
//  AudioManager.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 10.10.23.
//

import Foundation
import AVFoundation

final class AudioManager {
    private var audioPlayers: [AudioType: AVAudioPlayer] = [:]
    private var isMusicOn: Bool!
    private var areSoundsOn: Bool!
    private var storageManager: StorageManager!
    
    init(){
        storageManager = StorageManager()
        checkAudioSettings()
    }
    
    private func checkAudioSettings() {
        if let data = storageManager.get(key: "audioSettings", storageType: .userdefaults) as? Data {
            let decoder = JSONDecoder()
            if let audioSettings = try? decoder.decode(AudioSettings.self, from: data) {

                isMusicOn = audioSettings.isMusicOn
                areSoundsOn = audioSettings.areSoundsOn
            }
        } else {
            let audioSettings = AudioSettings(isMusicOn: true, areSoundsOn: true)
            
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(audioSettings) {
                storageManager.set(key: "audioSettings", value: encodedData, storageType: .userdefaults)
                isMusicOn = true
                areSoundsOn = true
            }
        }

    }
    
    
    func playAudio(type: AudioType) {
            var audioFile: String
            switch type {
            case .background:
                let audios = ["backgroundMusic1","backgroundMusic2"]
                audioFile = audios.randomElement() ?? audios[0]
            case .hit:
                let audios = ["hit1","hit2", "hit3"]
                audioFile = audios.randomElement() ?? audios[0]
            case .miss:
                audioFile = "miss"
            case .menu:
                audioFile = "menu"
            case .shot:
                let audios = ["shot1","shot2"]
                audioFile = audios.randomElement() ?? audios[0]
            case .finished:
                audioFile = "gameFinished"
            }
        
        
        if (type == .background && isMusicOn) || (type != .background && areSoundsOn) {
            if let audioFileURL = Bundle.main.url(forResource: audioFile, withExtension: "mp3") {
                do {
                    if let currentPlayer = audioPlayers[type] {
                        currentPlayer.stop()
                    }
                    
                    let audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
                    audioPlayers[type] = audioPlayer
                    
                    if type == .background {
                        audioPlayer.numberOfLoops = -1
                    }
                    
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                } catch {
                    print("Error initializing audio player: \(error)")
                }
            } else {
                print("Audio file not found")
            }
            
        }
        
    }
    
    func stopAudio(type: AudioType) {
        if let audioPlayer = audioPlayers[type] {
            audioPlayer.stop()
            audioPlayers[type] = nil
        }
    }
    
    func pauseAudio(type: AudioType) {
        if let audioPlayer = audioPlayers[type] {
            audioPlayer.pause()
        }
    }
}
