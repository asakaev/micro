#!/usr/bin/env sh
# Do - The Simplest Build Tool on Earth.
# Documentation and examples see https://github.com/8gears/do

set -e -u # -e "Automatic exit from bash shell script on error"  -u "Treat unset variables and parameters as errors"

fraud_compile() {
  # env
  scala_bin=~/toolchain/scala-2.6.1-final/bin
  dir=$PWD
  output="$dir/fraud/target/classes"

  # scan sources
  sources=$(find "$dir"/fraud -name '*.scala')

  # create classes directory
  mkdir -p "$output"

  # remove compiled classes
  rm -rf "${output:?}/*"

  # compile
  $scala_bin/scalac \
  -verbose \
  -target:jvm-1.4 \
  -extdirs /var/empty \
  -d "$output" \
  $sources
}

"$@" # <- execute the task

[ "$#" -gt 0 ] || printf "Usage:\n\t./do.sh %s\n" "($(compgen -A function | grep '^[^_]' | paste -sd '|' -))"
