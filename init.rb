APP_ROOT = File.dirname(__FILE__)

# require "#{APP_ROOT}/lib/guide"
# require File.join(APP_ROOT,'lib','guide')

$:.unshift( File.join(APP_ROOT, 'lib' ) )

require 'monopoly'
require 'fileutils'


#guide = Guide.new
#guide.launch!

monopoly = Monopoly.new
monopoly.launch!