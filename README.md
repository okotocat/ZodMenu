# ZodMenu 🧰🚀

[![Mod Status](https://img.shields.io/badge/status-active-brightgreen)](https://github.com/ZodiacLoneWolf/ZodMenu)
[![UE4SS Version](https://img.shields.io/badge/UE4SS-experimental-blue)](https://github.com/UE4SS/UE4SS)

## Description

**ZodMenu** is a multi-tool utility mod for *Drive Beyond Horizons* combining multiple popular features into a single package.  
Includes my stand-alone mods: **InfiBrush**, **IronGut**, **SpawnerMod**, and **TheFlash** speed boost functionality. With more to be added in future releases!

## ✅ Features

- **InfiBrush (F8)**  
  Makes **RustBrush** and **PolishBrush** unlimited.
  
- **IronGut (F9)**  
  Toggles **Hunger and Thirst** systems on/off.

- **SpawnerMod (DELETE / END)**  
  Opens an **Item Spawner Menu** to spawn available items.
  - **DELETE**: Open or close the Spawner.
  - **END, followed by left mouse button**: Restores controls and hides cursor if Spawner closes automatically.

- **TheFlash (F1)**  
  Applies a **massive forward speed boost** to your character.

## 🛠️ Installation

1. Make sure **UE4SS Experimental** is installed in your game directory.
2. Place `main.lua` into:
<YourGameDirectory>/DriveBeyondHorizons/Binaries/Win64/Mods/ZodMenu/Scripts/
3. Open `Mods.txt` located at:
<YourGameDirectory>/DriveBeyondHorizons/Binaries/Win64/Mods/Mods.txt
4. Add the following line:
ZodMenu : 1
5. Save the file and launch the game.

## 🎮 Keybinds & Usage

| Key   | Functionality                                |
|------|----------------------------------------------|
| F8   | Enable **InfiBrush** (Unlimited Brushes)     |
| F9   | Toggle **IronGut** (Hunger/Thirst On/Off)     |
| DELETE| Open **SpawnerMod** Menu                     |
| END + Left Click | Restore Controls After Spawner Closes |
| F1   | Activate **TheFlash** Speed Boost             |

## 📝 Notes

- Spawning an item **closes the SpawnerMenu automatically** (intended behavior).
- Use **END followed by Left Click** to fully restore controls if the menu closes itself after spawning an item or if closed via the button on the menu UI.
- Some items may be **missing** from the Spawner as it uses the **game's built-in debug list**. This is determined by the DBH devs. Missing assets can be spawned manually but the spawner does not include functional additions of missing items.
- **TheFlash** applies a single forward velocity boost on key press, not continuous speed.

## Known Issues

- **World Leak on Exit Game**  
- Exiting the game may trigger a **UE crash** due to limited cleanup capability.
- **SpawnerMenu Reopen Timing**  
- You may need to **press DELETE twice** to reopen after spawning an item.
- **Missing Items in Spawner**  
- Limited to items **provided by the developers** in the debug spawner.
- **Debug Menu Access Denied**  
- The **full debug menu** is intentionally **not included** for community safety.

## Credits

- Developed by **Zodiac987**
