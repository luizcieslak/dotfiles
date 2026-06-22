#!/bin/sh
cp .zshrc ~/.zshrc
mkdir -p ~/.config/Hyper
cp hyper.json ~/.config/Hyper/hyper.json
mkdir -p ~/.hyperinator
cp .hyperinator/*.yml ~/.hyperinator/
cp ssl.conf  ~/.ssl.conf