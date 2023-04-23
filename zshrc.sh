git clone https://github.com/zsh-users/zsh-autosuggestions /home/$USER/.zsh/zsh-autosuggestions
echo 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >> /home/$USER/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$USER/.zsh/zsh-syntax-highlighting
echo "source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /home/$USER/.zshrc

git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
sed -i "s/plugins=(git)/plugins=(git zsh-history-substring-search kubectl)/g" /home/$USER/.zshrc
echo "source /home/$USER/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" >> /home/$USER/.zshrc

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

chsh -s $(which zsh)

source ~/.zshrc
