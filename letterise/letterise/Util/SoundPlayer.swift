//
//  SoundPlayer.swift
//  letterise
//
//  Created by Lucas Justo on 21/11/23.
//

import AVFoundation

class SoundPlayer: NSObject, AVAudioPlayerDelegate {
    var player: AVAudioPlayer?
    let id: Int
    static var players: [SoundPlayer] = [] {
        didSet {
            print(SoundPlayer.players)
        }
    }
    static var semaphore: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    override init() {
        self.id = Date.now.hashValue
        super.init()
        SoundPlayer.players.append(self)
    }
    
    func playSound(sound: SoundOption) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self = self else { return }
            guard let url = Bundle.main.url(forResource: sound.resource, withExtension: sound.ext) else { return }
            
            do {
                self.player = try AVAudioPlayer(contentsOf: url)
                guard let player = self.player else { return }
                player.delegate = self
                
                player.prepareToPlay()
                player.play()
            } catch let error as NSError {
                print(error.description)
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        SoundPlayer.semaphore.wait()
        var index: Int = 0
        
        for i in 0..<SoundPlayer.players.count {
            if SoundPlayer.players[i].id == self.id {
                index = i
            }
        }
        
        SoundPlayer.players.remove(at: index)
        SoundPlayer.semaphore.signal()
    }
}

enum SoundOption {
    case correctAnswer, incorrectAnswer, tap
    
    var resource: String {
        switch self {
        case .correctAnswer:
            return "Correct"
        case .incorrectAnswer:
            return "Incorrect"
        case .tap:
            return "Tap"
        }
    }
    
    var ext: String {
        return "mp3"
    }
}
