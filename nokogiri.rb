# encoding: UTF-8
require 'nokogiri'
require 'open-uri'
 
host = 'http://tv.so-net.ne.jp'
url = host + '/chart/23.action?head=201504120000&span=24&chartWidth=950&cellHeight=3&sticky=true&descriptive=true&iepgType=0&buttonType=0 '

html = open(url)
doc = Nokogiri::HTML(html)

puts doc.css('a').length

doc.css('a').each do |item|
  if /^\/iepg.tvpi/ =~ item[:href] then
    puts host+item[:href]
    iepg = open(host+item[:href])
    tv = Nokogiri::HTML.parse(iepg, nil, "Shift_JIS")
    puts tv.to_s.encode("UTF-8", "Shift_JIS")
  end
end
