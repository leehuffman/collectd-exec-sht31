#/usr/bin/env bash

# Clones the Adafruit_Python_SHT31 repository to the vendor directory.
# The `sht31-temperature-humidity.rb` script relies on this.
set -e

DIRECTORY="vendor/Adafruit_Python_SHT31"

if [ ! -d "$DIRECTORY" ]; then
  git clone https://github.com/ralf1070/Adafruit_Python_SHT31.git $DIRECTORY
else
  cd $DIRECTORY && git pull origin master
fi
