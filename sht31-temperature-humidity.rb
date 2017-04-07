#!/usr/bin/env ruby

# A script for reading temperature and humidity values from an SHT31 on a
# Raspberry Pi.
#
# Adafruit Sensiron SHT31-D Temperature & Humidity Sensor Breakout
# https://www.adafruit.com/product/2857
#
# Python Driver for the Adafruit SHT31-D Breakout
# https://github.com/ralf1070/Adafruit_Python_SHT31
#
# <Plugin exec>
#   Exec <USER> "/PATH/TO/sht31-temperature-humidity.rb"
# </Plugin>

DIR      = File.expand_path(File.dirname(__FILE__))
HOSTNAME = ENV["COLLECTD_HOSTNAME"] || "localhost"
INTERVAL = ENV["COLLECTD_INTERVAL"] || 60
SHT31    = "#{DIR}/vendor/Adafruit_Python_SHT31/Adafruit_SHT31_Example.py"

unless File.executable?(SHT31)
  STDERR.puts "Can't execute #{SHT31}. Exiting."
  exit 1
end

def output
  `sudo python #{SHT31}`
end

def temperature
  temp = output.scan(/^Temp\s+= (\d+\.\d+)/).flatten.first.to_f
  (temp * 9/5 + 32).round(2) # Convert C to F
end

def humidity
  output.scan(/^Humidity\s+= (\d+\.\d+)/).flatten.first.to_f
end

while true
  time = `date +%s`.chop
  
  $stdout.puts %Q[PUTVAL #{HOSTNAME}/sensors/temperature interval=#{INTERVAL} #{time}:#{temperature}]
  $stdout.puts %Q[PUTVAL #{HOSTNAME}/sensors/humidity interval=#{INTERVAL} #{time}:#{humidity}]
  $stdout.flush

  sleep INTERVAL
end
