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
  cldc_jar=~/toolchain/jdk/cldc_1.1.jar
  midp_jar=~/toolchain/jdk/midp_1.0.jar
  jdk_jar=/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes/classes.jar:/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes/ui.jar:/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes/jsse.jar:/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes/jce.jar:/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Classes/charsets.jar

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

all_preverify() {
  # env
  preverify=~/toolchain/preverify
  bundle="$dir/hello/target/bundle"
  preverified="$dir/hello/target/preverified"

  # prepare bundle directory
  mkdir -p "$bundle"
  rm -rfv "${bundle:?}/"*

  # copy fraud and hello classes
  cp -r "$fraud_classes/." "$bundle"
  cp -r "$hello_classes/." "$bundle"

  # extract scala-library classes (no overwrite)
#  unzip -n $scala_lib_jar -d "$bundle"

  # remove scala-library junk
  rm -fv "$bundle/library.properties"
  rm -rfv "$bundle/META-INF"

#  # strip scala-library because of preverify errors
#  rm -rfv "$bundle/scala/xml"*
#  rm -rfv "$bundle/scala/testing"*
#  rm -rfv "$bundle/scala/mobile"*
#  rm -rfv "$bundle/scala/actors"*
#  rm -rfv "$bundle/scala/ref"*
#  rm -rfv "$bundle/scala/util"*
#  rm -rfv "$bundle/scala/text"*
#
#  # fix bb runtime error System.in
#  rm -v "$bundle/scala/Console.class"
#  rm -v "$bundle/scala/Console$.class"

  # TODO: fix bb runtime errors: Object.clone, String.lastIndexOf

  # prepare preverified directory
  mkdir -p "$preverified"
  rm -rfv "${preverified:?}/"*

  # preverify
  $preverify -classpath $cldc_jar:$midp_jar -d "$preverified" "$bundle"
}

hello_assembly() {
  # env
  preverified="$dir/hello/target/preverified"
  manifest="$dir/hello/src/main/resources/MANIFEST.MF"
  jar_dir="$dir/hello/target/jar"

  # prepare jar directory
  mkdir -p "$jar_dir"
  rm -rfv "${jar_dir:?}/"*

  # generate filename
  git_hash=$(git rev-parse --short HEAD)
  filename="hello-$git_hash.jar"

  # create jar
  jar cvfm "$jar_dir/$filename" "$manifest" -C "$preverified" .
}

hello_build() {
  fraud_compile && hello_compile && all_preverify && hello_assembly
}

hello_clean() {
  rm -rfv "${hello_target:?}/"*
}


clean() {
  fraud_clean && hello_clean
}


"$@" # <- execute the task

[ "$#" -gt 0 ] || printf "Usage:\n\t./do.sh %s\n" "($(compgen -A function | grep '^[^_]' | paste -sd '|' -))"
