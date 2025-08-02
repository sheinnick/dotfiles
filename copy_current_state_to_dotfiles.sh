cp ~/.bashrc  ./bashrc
cp ~/.zshrc   ./zshrc
cp ~/.aliases ./aliases

cp -R   ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ./oh-my-zsh/custom/plugins/zsh-autosuggestions/
cp -R   ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting  ./oh-my-zsh/custom/plugins/zsh-syntax-highlighting/

cp ~/.gitconfig ./git/.gitconfig
cp ~/.gitignore ./git/.gitignore

cp ~/.config/karabiner/karabiner.json ./karabiner.json

cp $HOME/Library/Application\ Support/Code/User/keybindings.json ./vscode/keybindings.json
cp $HOME/Library/Application\ Support/Code/User/settings.json ./vscode/settings.json