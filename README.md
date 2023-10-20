# The Long Story | Greedy Kings
Project planning tools

• [Miro](https://miro.com/app/board/uXjVMkG03_8=/?share_link_id=134224966956) <br/>
• [Jira](https://the-long-story.atlassian.net/jira/software/projects/LS/boards/1)


# Playgrounds of this project 
Below you can find our experiments on this project important parts

• [UIKitDynamics Gravity etc.](https://github.com/surenpoghosian/UikitDynamicsExperiments) <br/>
• [Collisions](https://github.com/GarikHovsepyan/UIKitDynamicsCollisionTests) <br/>
• [View Masking](https://github.com/surenpoghosian/viewMaskingExperiment) <br/>
• [Lottie Animations](https://github.com/surenpoghosian/LottieAnimationsiOS) <br/>
• [FirebaseSDK](https://github.com/surenpoghosian/FirebaseSDKTest) 

# Assets

• [Figma](https://www.figma.com/file/Hl29uOzYMh4mwdyZEW7LzK/The-Long-Story---Greedy-Kings-Game-UI?type=design&node-id=0-1&mode=design&t=H9i2z8GW5Si86SCE-0)
 
# Details
<b>Architecture - MVVM</b>

`Key Elements` <br/>
<pre>
• Level Manager (Builder)
• Physics Manager
• Game Manager
• Storage Manager
</pre>

<b>Architecture - MVVM</b>



Hierarchy
<pre>
├── Greedy Kings
│   ├── <strong>AnimationAssets</strong>
│   │   
│   ├── <strong>Application</strong>
│   │   ├── AppDelegate.swift
│   │   ├── Base.lproj
│   │   │   ├── LaunchScreen.storyboard
│   │   │   └── Main.storyboard
│   │   ├── RootViewController.swift
│   │   ├── SceneDelegate.swift
│   │   └── en.lproj
│   │       └── LaunchScreen.strings
│   │
│   ├── <strong>Assets.xcassets</strong>
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   ├── Contents.json
│   │   │   └── GreedyKingsIcon.png
│   │   ├── Contents.json
│   │   ├── <strong>UI Assets</strong>
│   │   │   ├── <strong>Buttons</strong>
│   │   │   ├── <strong>Cell Frames</strong>
│   │   │   ├── <strong>Color Sets</strong>
│   │   │   ├── <strong>Contents.json</strong>
│   │   │   ├── <strong>GameScene</strong>
│   │   │   ├── <strong>Icons</strong>
│   │   │   └── <strong>King Avatars</strong>
│   │   └── icon.imageset
│   ├── <strong>AudioAssets</strong>
│   ├── <strong>Extensions</strong>
│   ├── <strong>Game</strong>
│   │   ├── <strong>Constants</strong>
│   │   │   └── GameComponentsPropertyList.plist
│   │   └── <strong>UI</strong>
│   │       ├── <strong>Game Scene</strong>
│   │       │   ├── <strong>Models</strong>
│   │       │   │   ├── AnimationModels.swift
│   │       │   │   └── GameSceneModels.swift
│   │       │   ├── <strong>ViewModel</strong>
│   │       │   │   └── GameSceneViewModel.swift
│   │       │   └── <strong>Views</strong>
│   │       │       ├── Coordinator.swift
│   │       │       ├── GameSceneViewController.swift
│   │       │       ├── PauseViewController.swift
│   │       │       ├── PlayerDataViewController.swift
│   │       │       └── ResultViewController.swift
│   │       ├── <strong>Leaderboard</strong>
│   │       ├── <strong>Levels</strong>
│   │       ├── <strong>Main Menu</strong>
│   │       └── <strong>Pick Character</strong>
│   ├── <strong>Info.plist</strong>
│   └── <strong>Managers</strong>
│       ├── <strong>Game Manager</strong>
│       │   ├── GameManager.swift
│       │   ├── <strong>HealthManager</strong>
│       │   │   └── HealthManager.swift
│       │   └── <strong>Models</strong>
│       │       └── GameModels.swift
│       ├── <strong>Haptics Manager</strong>
│       ├── <strong>Level Manager</strong>
│       ├── <strong>Physics Manager</strong>
│       ├── <strong>Audio Manager</strong>
│       └── <strong>Storage Manager</strong>
├── <strong>Greedy KingsTests</strong>
│   └── Greedy_KingsTests.swift
├── <strong>Greedy KingsUITests</strong>
│   ├── Greedy_KingsUITests.swift
│   └── Greedy_KingsUITestsLaunchTests.swift
└── <strong>README.md</strong>
</pre>
