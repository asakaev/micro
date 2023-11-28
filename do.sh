#!/usr/bin/env sh
# Do - The Simplest Build Tool on Earth.
# Documentation and examples see https://github.com/8gears/do

set -e -u # -e "Automatic exit from bash shell script on error"  -u "Treat unset variables and parameters as errors"

# env
scala_dir=~/toolchain/scala-2.6.1-final
scala_bin=$scala_dir/bin
dir=$PWD

fraud_compile() {
  # env
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

hello_compile() {
  # env
  cldc_jar=~/toolchain/jdk/cldc_1.0.jar
  midp_jar=~/toolchain/jdk/midp_1.0.jar
  scala_lib_jar=$scala_dir/share/scala/lib/scala-library.jar
  fraud_classes="$dir/fraud/target/classes"
  output="$dir/hello/target/classes"

  # scan sources
  sources=$(find "$dir"/hello -name '*.scala')

  # create classes directory
  mkdir -p "$output"

  # remove compiled classes
  rm -rf "${output:?}/*"

  # compile
  $scala_bin/scalac \
  -verbose \
  -target:jvm-1.4 \
  -bootclasspath $cldc_jar:$midp_jar:$scala_lib_jar \
  -extdirs /var/empty \
  -classpath "$fraud_classes" \
  -d "$output" \
  $sources
}

"$@" # <- execute the task

[ "$#" -gt 0 ] || printf "Usage:\n\t./do.sh %s\n" "($(compgen -A function | grep '^[^_]' | paste -sd '|' -))"
