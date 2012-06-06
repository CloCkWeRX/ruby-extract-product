#! /usr/bin/env jruby

require "rubygems"
require "json"
require 'nokogiri'
require 'open-uri'

# Search is just prefetched content:
# https://www.google.com/search?sclient=psy-ab&hl=en&tbs=p_ord:p%2Cnew%3A1&tbm=shop&q=SPB10257&oq=SPB10257&aq=f&aqi=&aql=&gs_l=serp.12...0.0.3.692793.0.0.0.0.0.0.0.0..0.0...0.0.zZ7l8fwoGN0&pbx=1&bav=on.2,or.r_gc.r_pw.,cf.osb&fp=3ab34f38ee0d68eb&biw=1600&bih=494&tch=1&ech=1&psi=FkvOT-_DJ_HP4QTS47SzDA.1338922397378.11

file = File.open("search", "rb")
contents = file.read

data = contents.split('/*""*/')[7];

#There is probably a better way
{
  '\\x3c' => '<',
  '\\x3e' => '>',
  '\\x3d' => '=',
  '\\x22' => '"',
  '\\x26' => '&',
  '\\x27' => "'",
  "\\\\" => "\\",
  "\\<" => "<",
  "\\>" => ">",
  "\\=" => "=",
  '\\"' => '"',
  '\\&' => "&",
  "\\'" => "'",
  "script" => ""
}.each do |find, replace|
   data = data.gsub(find, replace)
end
#puts JSON(data)
data = data[0, data.length - 2]
data = data.split('d:"')[1]
doc = Nokogiri::HTML(data)

puts doc

#response including price, name, url to product, product text
product = {
  'price' => doc.xpath('//div[@class="psliprice"]/b/text()')[0].to_s,
  'name' => doc.xpath('//div[@class="pslimain"]/div/text()')[1].to_s,
  'url' => doc.xpath('//div[@class="pslimain"]/h3/a/@href')[0].to_s,
  'description' => doc.xpath('//div[@class="pslimain"]/div/text()')[2].to_s
}
puts product.inspect
