#!/usr/bin/env ruby
require 'unzipMe'
#
# A test program to determine the feasibility of recursively unzipping
# a ZIP file. That is, if the zip contains zips, the resulting extraction
# should explode the internal zips as well as the outer one.
#
FILE = ARGV.last

raise "Must specify zip file to unpack!" if FILE.nil?
raise "The specified file must exist: #{FILE}" unless File.exists?(FILE)

UNZIP_DIR = File.join(File.dirname(FILE), "extracted_files")

unzipper = RecursiveUnzipper.new(FILE)
unzipper.extract_to(UNZIP_DIR)
puts unzipper.exceptions.inspect unless unzipper.exceptions.empty?
