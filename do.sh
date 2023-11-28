#!/usr/bin/env sh
# Do - The Simplest Build Tool on Earth.
# Documentation and examples see https://github.com/8gears/do

set -e -u # -e "Automatic exit from bash shell script on error"  -u "Treat unset variables and parameters as errors"

# env
dir=$PWD
scala_dir=~/toolchain/scala-2.6.1-final
scalac=$scala_dir/bin/scalac
scala_lib_jar=$scala_dir/share/scala/lib/scala-library.jar
fraud_target="$dir/fraud/target"
hello_target="$dir/hello/target"
fraud_classes="$fraud_target/classes"
hello_classes="$hello_target/classes"


fraud_compile() {
  # scan sources
  sources=$(find "$dir"/fraud -name '*.scala')

  # prepare classes directory
  mkdir -p "$fraud_classes"
  rm -rfv "${fraud_classes:?}/"*

  # compile
  $scalac \
  -verbose \
  -target:jvm-1.4 \
  -extdirs /var/empty \
  -d "$fraud_classes" \
  $sources
}

fraud_clean() {
  rm -rfv "${fraud_target:?}/"*
}


hello_compile() {
  # env
  cldc_jar=~/toolchain/jdk/cldc_1.0.jar
  midp_jar=~/toolchain/jdk/midp_1.0.jar

  # scan sources
  sources=$(find "$dir"/hello -name '*.scala')

  # prepare classes directory
  mkdir -p "$hello_classes"
  rm -rfv "${hello_classes:?}/"*

  # compile
  $scalac \
  -verbose \
  -target:jvm-1.4 \
  -bootclasspath $cldc_jar:$midp_jar:$scala_lib_jar \
  -extdirs /var/empty \
  -classpath "$fraud_classes" \
  -d "$hello_classes" \
  $sources
}

hello_assembly() {
  # env
  tmp="$dir/hello/target/tmp"
  manifest="$dir/hello/src/main/resources/MANIFEST.MF"
  jar_dir="$dir/hello/target/jar"

  # prepare tmp directory
  mkdir -p "$tmp"
  rm -rfv "${tmp:?}/"*

  # extract scala-library classes
  unzip $scala_lib_jar -d "$tmp"

  # remove scala-library junk
  rm -fv "$tmp/library.properties"
  rm -rfv "$tmp/META-INF"

  # copy fraud and hello classes
  cp -r "$fraud_classes/." "$tmp"
  cp -r "$hello_classes/." "$tmp"

  # prepare jar directory
  mkdir -p "$jar_dir"
  rm -rfv "${jar_dir:?}/"*

  # generate filename
  git_hash=$(git rev-parse --short HEAD)
  filename="hello-$git_hash.jar"

  # create jar
  jar cvfm "$jar_dir/$filename" "$manifest" -C "$tmp" .
}

hello_build() {
  fraud_compile && hello_compile && hello_assembly
}

hello_clean() {
  rm -rfv "${hello_target:?}/"*
}


clean() {
  fraud_clean && hello_clean
}


"$@" # <- execute the task

[ "$#" -gt 0 ] || printf "Usage:\n\t./do.sh %s\n" "($(compgen -A function | grep '^[^_]' | paste -sd '|' -))"
