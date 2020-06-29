#!/bin/sh

# uname_os converts `uname -s` into standard golang OS types
# golang types are used since they cover
# most platforms and are standardized while raw uname values vary
# wildly.  See complete list of values by running
# "go tool dist list"
#
# ## EXAMPLE
#
# ```bash
# OS=$(uname_os)
# ```
#
uname_os() {
  os=$(uname -s | tr '[:upper:]' '[:lower:]')

  # fixed up for https://github.com/client9/shlib/issues/3
  case "$os" in
    msys*) os="windows" ;;
    mingw*) os="windows" ;;
    cygwin*) os="windows" ;;
    win*) os="windows" ;; # for windows busybox and like # https://frippery.org/busybox/
  esac

  # Sun Solaris and derived OS (Illumos, Oracle Solaris) reports to be the very ancient SunOS via uname not what it actually is
  if [ "$os" = "sunos" ]; then
    # GO 1.13 will introduce illumos as newly recognized GOOS
    if ! grep -q illumos /etc/release; then
      if go version | grep -q "1.13"; then
        os="illumos"
      else
        os="solaris"
      fi
    else
      os="solaris"
    fi
  fi

  # other fixups here
  echo "$os"
}
