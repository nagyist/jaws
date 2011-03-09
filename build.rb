#!/usr/bin/env ruby

#
# Build standalone,all-including jaws-all.js by combining all files in src/-directory into one
#
out = File.new("jaws-all.js", "w")
Dir["src/*"].each do |file|
  out.write(File.read(file))
end
out.close

#
# Minify jaws-all.js into jaws-min.js using googles closure compiler
#
require 'net/http'
require 'uri'
def compress(js_code, compilation_level)
  response = Net::HTTP.post_form(URI.parse('http://closure-compiler.appspot.com/compile'), {
    'js_code' => js_code,
    'compilation_level' => "#{compilation_level}",
    'output_format' => 'text',
    'output_info' => 'compiled_code'
  })
  response.body
end

js_code = File.read("jaws-all.js")

out = File.new("jaws-min.js", "w")
out.write compress(js_code, "SIMPLE_OPTIMIZATIONS") # ADVANCED_OPTIMIZATIONS
out.close

