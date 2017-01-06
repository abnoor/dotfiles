-- Import Statements
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders

-- Define workspaces
myWorkspaces = ["1:main", "2:code", "3:web", "4:media", "5:comms", "6:prod", "7:misc"]

-- Run xmonad
main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ defaultConfig { 
          manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = smartBorders $ avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        --,ppTitle = (\str ->"")
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , workspaces = myWorkspaces
        , handleEventHook = fullscreenEventHook -- Allow apps to go fullscreen
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
        , ((0, xK_Print), spawn "scrot")
        ]
