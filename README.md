# Godot Facebook SDK
[![Godot](https://img.shields.io/badge/Godot%20Engine-3.6-blue?style=for-the-badge&logo=godotengine&logoSize=auto)](https://godotengine.org/)
[![Facebook SDK](https://img.shields.io/badge/Facebook_SDK-blue?style=for-the-badge&logoSize=auto)](https://developers.facebook.com/docs/android/)
[![GitHub License](https://img.shields.io/github/license/damnedpie/godot-facebook?style=for-the-badge)](#)
[![GitHub Repo stars](https://img.shields.io/github/stars/damnedpie/godot-facebook?style=for-the-badge&logo=github&logoSize=auto&color=%23FFD700)](#)

Facebook SDK Android plugin for Godot. Built on Godot 3.6 AAR.

## Author's note

[Based on Dr. Moriarty's work.](https://github.com/DrMoriarty/godot-facebook)

## Setup

### Project integration

Grab the``GodotFacebook`` plugin binary (.aar) and config (.gdap) from the releases page and put both into ``res://android/plugins``. For easy start, you can also use ``GodotFacebook.gd`` script as an autoload.

Make sure that you add your Facebook App ID and Facebook Client Token to your app manifest as per the [original documentation by Facebook.](https://developers.facebook.com/docs/android/getting-started/)
