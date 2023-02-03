# Elm Word Guesser

This is an Elm application that allows the user to guess a randomly selected word from a list. The user is presented with the definitions of the word and can input their guess. If the user's guess is correct, they are congratulated.

## Requirements

* Elm version 0.19.1 or latest
* An HTTP server that serves words.txt at http://localhost:8000/ELM/words.txt. This file contains a list of words.

## Running the Application

To run the application, install Elm and use the following command in the root directory of the project:

`elm reactor`

Then open Main.elm or index.html from http://localhost:8000 in your browser. The main.js file is the Javascript converted file of the Main.elm.

## Functionality

* The application fetches a list of words from the file words.txt hosted in your HTTP server and selects a random word from the list.
* The user is presented with the definitions of the selected word and can input its guess.
* If the user's guess is correct, he's congratulated.
* The user can get a new word by clicking the "Next Word" button.
* The user can reveal the word by clicking the "Show Word" button.
* If no word has been choosen while launching the application, the user can reaload it by clicking the "Start" button.


