# About
Pynstall is a local python installer with integration with [virtualenv]/[virtualenvwrapper], inspired by [nmv]
# Prerequisites
  * openssl dev library
  * virtualenvwrapper
  * wget

# Usage
  List available python version
  
  `$pynstall ls-remote`
  
  Install specific python release
  
  `$pynstall install 3.4.0`
  
  or
  
  `$pynstall install Python-3.4.0`
  
  List installed python version
  
  `$pynstall ls`
  
  Create a base virtualenv using virtualenvwrapper (If version already installed)
  
  `$pynstall install-ve 3.4.0`
  
  Uninstall release
  
  `pynstall uninstall 3.4.0`

[virtualenv]:https://virtualenv.pypa.io/en/stable
[virtualenvwrapper]:https://virtualenvwrapper.readthedocs.io/en/latest
[nvm]:https://github.com/creationix/nvm
