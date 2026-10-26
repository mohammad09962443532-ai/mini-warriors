# Mini Warriors — Godot Starter Prototype

This is a **starter project**, not a finished APK. It provides a small 2D side-view shooter prototype with a player, jetpack, bots, basic shooting, platforms, and on-screen buttons.

## Requirements
- Godot Engine 4.3 or newer
- Android export templates for building an APK
- Android SDK/JDK configured in Godot for Android export

## Run on a computer
1. Install Godot 4.3+.
2. Open `project.godot`.
3. Press Play (F6/F5).

## Export to Android APK
1. Install Android export templates from Godot's editor.
2. Configure Android SDK and Java SDK in Editor Settings.
3. Add an Android export preset in Project > Export.
4. Set package name and signing options.
5. Export a debug APK for testing.

## Important limitations
- Local Wi-Fi multiplayer is **not implemented yet**.
- This prototype uses simple vector-drawn characters and shapes; it does not yet include polished art, music, full collision-aware map design, menus, or save data.
- The target size of 30–40 MB is a goal, not guaranteed. A prototype may be much smaller; assets and audio can increase size.
- Test gameplay and Android touch controls on a real device before distributing.

## Suggested next milestones
1. Add reliable player/bot collision and level boundaries.
2. Add a start menu, pause screen, weapon pickup system, and multiple maps.
3. Implement Wi-Fi LAN lobby and synchronization.
4. Replace placeholder drawings with original art and audio.
5. Profile performance and tune Android export size.
