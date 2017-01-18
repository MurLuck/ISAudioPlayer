//
//  ISAudioPlayerManager.swift
//  ISAudioPlayer
//
//  Created by Igor Sokolovsky on 1/14/17.
//  Copyright © 2017 Igor Sokolovsky. All rights reserved.
//

import Foundation
import AVFoundation
import ISSwiftLogger

public func clearPlayersCach(){
    ISAudioPlayerManager.shared.deinitPlayers()
}

protocol ISAudioPlayerManagerDelegate{
	
	func didStopPlayer()
	
	func didPlayPlayer()
	
	func didPausePlayer()
	
	func didFinishPlaying()
	
	func didDeinitilizePlayer()
	
	func didUpdatePlayerCurrentPosition()
}

class ISAudioPlayerManager:NSObject{
    
    static let shared = ISAudioPlayerManager()
    
    fileprivate let playerCach:NSMutableDictionary = NSMutableDictionary()
    
    fileprivate var activePlayer:String = ""
    
    fileprivate var delegate:ISAudioPlayerManagerDelegate?
    
    private override init(){}
    
    func initPlayer(withPath:String,showLogs:Bool){
        initPlayer(withPath: withPath, uniqeId:String.uuid,showLogs:showLogs)
    }
    
    func initPlayer(withPath:String,uniqeId:String,showLogs:Bool){
        do {
            let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: withPath))
            player.prepareToPlay()
            player.delegate = self
			
            playerCach.setValue(player, forKey: uniqeId)
        }catch{
            logger.showVerbose = showLogs
            logger.error(error.localizedDescription)
        }
    }
    
    func deinitPlayer(uuid:String){
        if let player = playerCach.value(forKey: uuid) as? AVAudioPlayer{
			
			if uuid == activePlayer{
				delegate?.didDeinitilizePlayer()
			}
			
            player.stop()
            playerCach.removeObject(forKey: uuid)
        }
    }
    
    func deinitPlayers(){
        for key in playerCach.allKeys{
            guard key is String else{
                continue
            }
            deinitPlayer(uuid: key as! String)
        }
        
        playerCach.removeAllObjects()
    }
    
    func currentPosition(uuid:String,showLogs:Bool)->TimeInterval?{
        
        if let player = playerCach.value(forKey: uuid) as? AVAudioPlayer{
            return player.currentTime
        }
        
        logger.showVerbose = showLogs
        logger.error("Player deasnt exist")
		
        return nil
    }
	
	func getDuration(uuid:String,showLogs:Bool)->TimeInterval?{
		
		if let player = playerCach.value(forKey: uuid) as? AVAudioPlayer{
			return player.duration
		}
		
		        logger.showVerbose = showLogs
		        logger.error("Player deasnt exist")
		
		return nil
	}
	
    func setPosition(uuid:String,showLogs:Bool,position:TimeInterval){
        if let player = playerCach.value(forKey: uuid) as? AVAudioPlayer{
            player.currentTime = position
			delegate?.didUpdatePlayerCurrentPosition()
        }else{
            logger.showVerbose = showLogs
            logger.error("Player deasnt exist")
			
        }
    }
    
    func play(uuid:String,showLogs:Bool,delegate:ISAudioPlayerManagerDelegate?){
        do{
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
			try AVAudioSession.sharedInstance().setActive(true)
			
            if !activePlayer.isEmpty && activePlayer != uuid{
                if let player = playerCach.value(forKey: activePlayer) as? AVAudioPlayer{
                    player.pause()
					self.delegate?.didPausePlayer()
                    logger.info("\(activePlayer) stoped playing")
                }
            }
            
            if let player = playerCach.value(forKey: uuid) as? AVAudioPlayer{
                player.play()

                activePlayer = uuid
                self.delegate = delegate
				self.delegate?.didPlayPlayer()
                logger.info("\(uuid) started playing")
            }else{
                logger.showVerbose = showLogs
                logger.error("Player deasnt exist")
            }
        }catch{
            logger.showVerbose = showLogs
            logger.error(error.localizedDescription)
        }
    }
    
    func pause(uuid:String,showLogs:Bool){
        do{
            if let player = playerCach.value(forKey: uuid) as? AVAudioPlayer{
                player.pause()
				
				delegate?.didPausePlayer()
                activePlayer = ""
            }else{
                logger.showVerbose = showLogs
                logger.error("Player deasnt exist")
            }
            try AVAudioSession.sharedInstance().setActive(false)
        }catch{
            logger.showVerbose = showLogs
            logger.error(error.localizedDescription)
        }
    }
    
    func stop(uuid:String,showLogs:Bool){
        do{
            if let player = playerCach.value(forKey: uuid) as? AVAudioPlayer{
                player.stop()
				delegate?.didStopPlayer()
            }else{
                logger.showVerbose = showLogs
                logger.error("Player deasnt exist")
            }
            try AVAudioSession.sharedInstance().setActive(false)
        }catch{
            logger.showVerbose = showLogs
            logger.error(error.localizedDescription)
        }
    }
	
	func isPlaying(uuid:String)->Bool{
		if let player = playerCach.value(forKey: uuid) as? AVAudioPlayer{
			return player.isPlaying
		}
		
		return false
	}
}

extension ISAudioPlayerManager:AVAudioPlayerDelegate{
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		player.currentTime = 0
		delegate?.didFinishPlaying()
	}
	
	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
	}
}

