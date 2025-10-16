/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

brew --version


brew install ruby


echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

ruby -v

gem update --system
gem install bundler

gem install --user-install cocoapods
echo 'export PATH="$HOME/.gem/ruby/$(ruby -e "print RUBY_VERSION")/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

sudo gem install -n /usr/local/bin cocoapods

bundle install
bundle exec pod install

