#!/bin/bash
# macOS (Apple Silicon or Intel) counterpart of install.sh. Safe to re-run:
# every step skips itself when already done. Steps that need sudo or an
# Apple ID can't run unattended; they are listed at the end with the exact
# command to run, and a re-run afterwards picks up where it left off.

cd "$(dirname "$0")" || exit 1
DOTFILES=$(pwd)

TODO=""
FAILED=""
todo() { TODO="$TODO\n  - $1"; }
fail() { FAILED="$FAILED\n  - $1"; echo "!!! failed: $1"; }
step() { echo; echo "### $1 ###"; }
have() { command -v "$1" >/dev/null 2>&1; }
# Large downloads (Android Studio, the emulator) sometimes get their
# connection reset midway; a fresh attempt usually goes through.
retry() {
  for _attempt in 1 2 3; do
    "$@" && return 0
    [ "$_attempt" = 3 ] || echo "retrying ($_attempt/3): $*"
  done
  return 1
}

load_brew() {
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$b" ] && eval "$("$b" shellenv)" && return 0
  done
  return 1
}

load_nvm() {
  export NVM_DIR="$HOME/.nvm"
  # nvm.sh returns non-zero when no default alias exists yet.
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" || true
}

brew_install() {
  # $1: formula, or "--cask name"
  if [ "$1" = --cask ]; then
    brew list --cask "$2" >/dev/null 2>&1 || retry brew install --cask "$2" || fail "brew install --cask $2"
  else
    brew list "$1" >/dev/null 2>&1 || retry brew install "$1" || fail "brew install $1"
  fi
}

step "xcode command line tools"
if xcode-select -p >/dev/null 2>&1; then
  echo "already installed"
else
  xcode-select --install
  todo "finish the Xcode Command Line Tools dialog, then re-run this script"
fi

step "homebrew"
if load_brew; then
  echo "already installed: $(brew --version | head -1)"
else
  todo 'install Homebrew (needs your password), then re-run this script:
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
fi

# brew refuses every command while the Xcode license is pending.
if have brew && ! xcrun clang --version >/dev/null 2>&1; then
  todo "accept the Xcode license (brew refuses to run until you do), then re-run this script:
      sudo xcodebuild -license accept"
elif have brew; then
  step "brew packages"
  for f in git atuin shellcheck watchman cocoapods openjdk@17; do brew_install "$f"; done
  brew_install --cask android-studio
  # Docker Desktop's cask asks for sudo; brew fails without a terminal to ask in.
  if [ -d /Applications/Docker.app ]; then
    echo "docker already installed"
  elif sudo -n true 2>/dev/null; then
    brew_install --cask docker-desktop
  else
    todo "install Docker Desktop (needs your password), then open it once to accept its terms:
      brew install --cask docker-desktop && open -a Docker"
  fi
fi

step "oh-my-zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "already installed"
else
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    || fail "oh-my-zsh"
fi
[ "$(dscl . -read "/Users/$(whoami)" UserShell | awk '{print $2}')" = /bin/zsh ] \
  || todo "make zsh your login shell: chsh -s /bin/zsh"

step "nvm + node LTS"
if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
  tag=$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')
  # PROFILE=/dev/null: .zshrc from this repo already loads nvm.
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${tag:-v0.40.3}/install.sh" | PROFILE=/dev/null bash \
    || fail "nvm"
fi
load_nvm
if have nvm; then
  nvm ls --no-colors lts/* >/dev/null 2>&1 || nvm install --lts || fail "node LTS"
  nvm alias default 'lts/*' >/dev/null
  nvm use default >/dev/null
  echo "node $(node -v)"
fi

step "pnpm, yarn, safe-chain"
if have npm; then
  for p in pnpm yarn @aikidosec/safe-chain; do
    npm ls -g --depth=0 "$p" >/dev/null 2>&1 || npm install -g "$p" || fail "npm install -g $p"
  done
  if [ ! -f "$HOME/.safe-chain/scripts/init-posix.sh" ] && have safe-chain; then
    safe-chain setup || fail "safe-chain setup"
  fi
fi

step "conda (miniforge)"
if [ -x "$HOME/miniforge3/bin/conda" ]; then
  echo "already installed"
else
  tmp=$(mktemp -d)
  if ! { retry curl -fsSL -o "$tmp/miniforge.sh" \
           "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-$(uname -m).sh" \
         && bash "$tmp/miniforge.sh" -b -p "$HOME/miniforge3"; }; then
    fail "miniforge"
  fi
  rm -rf "$tmp"
fi

step "z jumper"
[ -f "$HOME/z.sh" ] || curl -fsSL -o "$HOME/z.sh" https://raw.githubusercontent.com/rupa/z/master/z.sh || fail "z.sh"

step "git"
git config --global core.autocrlf input

step "android sdk"
JDK="$(brew --prefix openjdk@17 2>/dev/null)/libexec/openjdk.jdk/Contents/Home"
if [ -x "$JDK/bin/java" ]; then
  export JAVA_HOME="$JDK"
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  sdkmanager="$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager"
  if [ ! -x "$sdkmanager" ]; then
    ver=$(curl -fsSL https://dl.google.com/android/repository/repository2-1.xml \
      | sed -n 's/.*commandlinetools-mac-\([0-9]*\)_latest.zip.*/\1/p' | sort -n | tail -1)
    tmp=$(mktemp -d)
    if ! { retry curl -fsSL -o "$tmp/clt.zip" "https://dl.google.com/android/repository/commandlinetools-mac-${ver}_latest.zip" \
           && unzip -q "$tmp/clt.zip" -d "$tmp" \
           && mkdir -p "$ANDROID_HOME/cmdline-tools" \
           && mv "$tmp/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"; }; then
      fail "android cmdline-tools"
    fi
    rm -rf "$tmp"
  fi
  if [ -x "$sdkmanager" ]; then
    yes | "$sdkmanager" --licenses >/dev/null
    list=$("$sdkmanager" --list 2>/dev/null)
    api=$(echo "$list" | sed -n 's/^ *platforms;android-\([0-9][0-9]*\) .*/\1/p' | sort -n | tail -1)
    abi=$([ "$(uname -m)" = arm64 ] && echo arm64-v8a || echo x86_64)
    # A new API level ships before its emulator image does, so the emulator
    # uses the newest level that has one.
    img_api=$(echo "$list" | sed -n "s/^ *system-images;android-\([0-9][0-9]*\);google_apis;$abi .*/\1/p" | sort -n | tail -1)
    image="system-images;android-$img_api;google_apis;$abi"
    # One package per call: sdkmanager drops the whole batch when one
    # download fails, so the big system image would hold the rest back.
    for pkg in platform-tools emulator "platforms;android-$api" "$image"; do
      retry "$sdkmanager" "$pkg" >/dev/null || fail "sdkmanager $pkg"
    done
    avdmanager="$ANDROID_HOME/cmdline-tools/latest/bin/avdmanager"
    avd="Pixel_API_$img_api"
    if [ -f "$ANDROID_HOME/system-images/android-$img_api/google_apis/$abi/package.xml" ] \
      && ! "$avdmanager" list avd -c 2>/dev/null | grep -qx "$avd"; then
      echo no | "$avdmanager" create avd -n "$avd" -k "$image" -d pixel_7 >/dev/null || fail "create AVD $avd"
    fi
    echo "android-$api, AVDs: $("$avdmanager" list avd -c 2>/dev/null | tr '\n' ' ')"
  fi
else
  echo "skipped: needs openjdk@17 from Homebrew"
fi

step "xcode"
XCODE_SETUP="sudo xcode-select -s /Applications/Xcode.app && sudo xcodebuild -license accept && sudo xcodebuild -runFirstLaunch && xcodebuild -downloadPlatform iOS"
if [ ! -d /Applications/Xcode.app ]; then
  todo "install Xcode (needs your Apple ID) from the App Store, or: brew install xcodes && xcodes install --latest
      then run: $XCODE_SETUP"
elif [ "$(xcode-select -p)" != /Applications/Xcode.app/Contents/Developer ] \
  || ! xcodebuild -checkFirstLaunchStatus >/dev/null 2>&1; then
  todo "point the toolchain at Xcode, accept its license and install the iOS simulator:
      $XCODE_SETUP"
elif ! xcrun simctl list runtimes 2>/dev/null | grep -q '^iOS'; then
  xcodebuild -downloadPlatform iOS || fail "iOS simulator runtime"
else
  echo "ready: $(xcodebuild -version | head -1), $(xcrun simctl list runtimes | grep '^iOS' | tail -1)"
fi

step "copying my dotfiles"
sh "$DOTFILES/copy.sh" || fail "copy.sh"

echo
if [ -n "$FAILED" ]; then printf "### failed:%b\n" "$FAILED"; fi
if [ -n "$TODO" ]; then printf "### left for you:%b\n" "$TODO"; fi
[ -z "$FAILED$TODO" ] && echo "### all done. open a new terminal. ###"
[ -z "$FAILED" ]
