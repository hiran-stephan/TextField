sudo rm -rf /Users/Stephan/Library/Java/JavaVirtualMachines/corretto-22.0.2
sudo rm -rf /Library/Java/JavaVirtualMachines/jdk-17.jdk
                                                                            
                                                                            
export JAVA_HOME=/Users/Stephan/Library/Java/JavaVirtualMachines/corretto-17.0.12/Contents/Home


echo 'export JAVA_HOME=/Users/Stephan/Library/Java/JavaVirtualMachines/corretto-17.0.12/Contents/Home' >> ~/.zshrc
source ~/.zshrc

/usr/libexec/java_home -V

java -version


