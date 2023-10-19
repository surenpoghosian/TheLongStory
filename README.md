# The Long Story | Greedy Kings

• [Miro](https://miro.com/app/board/uXjVMkG03_8=/?share_link_id=134224966956) <br/>
• [Jira](https://the-long-story.atlassian.net/jira/software/projects/LS/boards/1)


# Playgrounds of this project 
Below you can find our experiments on this project important parts

• [UIKitDynamics Gravity etc.](https://github.com/surenpoghosian/UikitDynamicsExperiments) <br/>
• [Collisions](https://github.com/GarikHovsepyan/UIKitDynamicsCollisionTests) <br/>
• [View Masking](https://github.com/surenpoghosian/viewMaskingExperiment) <br/>
• [Lottie Animations](https://github.com/surenpoghosian/LottieAnimationsiOS) <br/>
• [FirebaseSDK](https://github.com/surenpoghosian/FirebaseSDKTest) 



# Details

Architecture - MVVM

Hierarchy

├── Greedy Kings
│   ├── `AnimationAssets`
│   │   
│   ├── `Application`
│   │   ├── AppDelegate.swift
│   │   ├── Base.lproj
│   │   │   ├── LaunchScreen.storyboard
│   │   │   └── Main.storyboard
│   │   ├── RootViewController.swift
│   │   ├── SceneDelegate.swift
│   │   └── en.lproj
│   │       └── LaunchScreen.strings
│   │
│   ├── `Assets.xcassets`
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   ├── Contents.json
│   │   │   └── GreedyKingsIcon.png
│   │   ├── Contents.json
│   │   ├── `UI Assets`
│   │   │   ├── `Buttons`
│   │   │   ├── `Cell Frames`
│   │   │   ├── `Color Sets`
│   │   │   ├── `Contents.json`
│   │   │   ├── `GameScene`
│   │   │   ├── `Icons`
│   │   │   └── `King Avatars`
│   │   └── icon.imageset
│   ├── `AudioAssets`
│   ├── `Extensions`
│   ├── `Game`
│   │   ├── `Constants`
│   │   │   └── GameComponentsPropertyList.plist
│   │   └── `UI`
│   │       ├── `Game Scene`
│   │       │   ├── `Models`
│   │       │   │   ├── AnimationModels.swift
│   │       │   │   └── GameSceneModels.swift
│   │       │   ├── `ViewModel`
│   │       │   │   └── GameSceneViewModel.swift
│   │       │   └── `Views`
│   │       │       ├── Coordinator.swift
│   │       │       ├── GameSceneViewController.swift
│   │       │       ├── PauseViewController.swift
│   │       │       ├── PlayerDataViewController.swift
│   │       │       └── ResultViewController.swift
│   │       ├── `Leaderboard`
│   │       ├── `Levels`
│   │       ├── `Main Menu`
│   │       └── `Pick Character`
│   ├── `Info.plist`
│   └── `Managers`
│       ├── `Game Manager`
│       │   ├── GameManager.swift
│       │   ├── `HealthManager`
│       │   │   └── HealthManager.swift
│       │   └── `Models
│       │       └── GameModels.swift
│       ├── `Haptics Manager`
│       ├── `Level Manager`
│       ├── `Physics Manager`
│       ├── `Audio Manager`
│       └── `Storage Manager`
├── `Greedy KingsTests`
│   └── Greedy_KingsTests.swift
├── `Greedy KingsUITests`
│   ├── Greedy_KingsUITests.swift
│   └── Greedy_KingsUITestsLaunchTests.swift
└── `README.md`
