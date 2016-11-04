# WeatherGuru

## Authors
* Yadel Abraham
* Aldo Mendez

## Purpose
WeatherGuru gives you a list of suggested activities within a specified 
location based on that location's weather.

## Features
* Ability to use current location or specicify a different location for upcoming travel
* Scroll through list of suggested activities

## Control Flow
* User is initially presented with splash screen
* User will then be asked for permission for their current location 
(They may opt to manually enter a different location instead)
* They will be presented with list of suggested activities based on the weather

## Implementation
### Model
* AppDelegate.swift

### View
* SplashView
* ActivitiesListTableView

### Controller
* SplashViewController
* ActivitiesListTableViewController
