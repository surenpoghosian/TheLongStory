//
//  Greedy_KingsUITests.swift
//  Greedy KingsUITests
//
//  Created by Suren Poghosyan on 21.09.23.
//

import XCTest
@testable import Greedy_Kings


final class Greedy_KingsUITests: XCTestCase {

    var app: XCUIApplication!
    var storageManager: StorageManager!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        storageManager = StorageManager()
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .landscapeLeft
    }

    override func tearDownWithError() throws {
        app = nil
        storageManager = nil
    }

    func testMenuButtons() throws {
        app.launch()
//        let continueButton = app.buttons["playButton"]
        let playButton = app.buttons["playButton"]
        let leaderboardButton = app.buttons["leaderboardButton"]
        let settingsButton = app.buttons["settingsButton"]
        let musicSettingsButton = app.buttons["musicSettingsButton"]
        let soundsSettingsButton = app.buttons["soundsSettingsButton"]
        let backButtonInPickCharactersPage = app.buttons["pickCharacterPageBackButton"]
        let backButtonInLeaderBoardPage = app.buttons["leaderboardPageBackButton"]
        

        
        XCTAssertFalse(musicSettingsButton.isHittable)
        XCTAssertFalse(soundsSettingsButton.isHittable)
        

        settingsButton.tap()
        
        XCTAssertTrue(musicSettingsButton.isHittable)
        XCTAssertTrue(soundsSettingsButton.isHittable)
        
        musicSettingsButton.tap()

        musicSettingsButton.tap()

        soundsSettingsButton.tap()
        
        soundsSettingsButton.tap()

        
        playButton.tap()
        if getCurrentPageName() != .pickcharacter {
            XCTFail("Play button didn't navigate to pick characters page")
        }
        
        backButtonInPickCharactersPage.tap()

        if getCurrentPageName() != .mainmenu {
            XCTFail("backButtonInPickCharactersPage didn't navigate back to main menu page")
        }

        leaderboardButton.tap()
        
        if getCurrentPageName() != .leaderboard {
            XCTFail("leaderboardButton didn't navigate to leaderboard page")
        }

        backButtonInLeaderBoardPage.tap()
        
        if getCurrentPageName() != .mainmenu {
            XCTFail("backButtonInLeaderBoardPage didn't navigate to main menu page")
        }

        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func getCurrentPageName() -> CurrentPage? {
        let app = XCUIApplication()

        if app.buttons["pickCharacterPageBackButton"].exists {
            return .pickcharacter
        } else if app.buttons["leaderboardPageBackButton"].exists {
            return .leaderboard
        } else if app.buttons["scenesPageBackButton"].exists {
            return .pickscene
        } else if app.buttons["gamescenePauseButton"].exists {
            return .gamescene
        } else if app.buttons["playButton"].exists {
            return .mainmenu
        }


        return nil
    }
}



enum CurrentPage {
    case mainmenu
    case pickcharacter
    case pickscene
    case gamescene
    case leaderboard
}
