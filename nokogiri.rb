# encoding: UTF-8
require 'nokogiri'
require 'open-uri'

#Define
station = "station:"
station_name = "station-name:"
year = "year:"
month = "month:"
date = "date:"
start_time = "start:"
end_time = "end:"
title = "program-title:"
subtitle = "program-subtitle:"
performer = "performer:"
subperformer = "subperformer:"
id = "program-id:"
genre = "genre-1:"
subgenre = "subgenre-1:"
gomi = "</p></body></html>"
 
#def to_myhash(str)
#    str.scan(/(\w+):\s+(\d+)/).map{|k, v| [k.to_sym, v.to_i] }
#end

day = Date.today
today = day.strftime("%Y%m%d")

days = Array.new
(0..7).each do |d|
  #p (day+d).strftime("%Y%m%d")
  days.push((day+d).strftime("%Y%m%d"))
end

days.each do |d|
  p d
end

host = 'http://tv.so-net.ne.jp'
url = host + '/chart/23.action?head=' + today + '0000&span=24&chartWidth=950&cellHeight=3&sticky=true&descriptive=true&iepgType=0&buttonType=0 '

html = open(url)
doc = Nokogiri::HTML(html)

puts doc.css('a').length

json = "[ "
doc.css('a').each do |item|
  if /^\/iepg.tvpi/ =~ item[:href] then
    puts host+item[:href]
    iepg = open(host+item[:href])
    tv_sjis = Nokogiri::HTML.parse(iepg, nil, "Shift_JIS")
    #puts tv_sjis.to_s.encode("UTF-8", "Shift_JIS")
    tv = tv_sjis.to_s.encode("UTF-8", "Shift_JIS")
    #Jsonに変換
    count = 0
    json += "{"
    tv.each_line do |line|
      count += 1
      str = line.chomp
      #p str
      if str.index(station) == 0 then
        p str[station.length+1..str.length]
        json += station + str[station.length+1..str.length] + ","
      elsif str.index(station_name) == 0 then
        p str[station_name.length+1..str.length]
        json += station_name + str[station_name.length+1..str.length] + ","
      elsif str.index(year) == 0 then
        p str[year.length+1..str.length]
        json += year + str[year.length+1..str.length] + ","
      elsif str.index(month) == 0 then
        p str[month.length+1..str.length]
        json += month + str[month.length+1..str.length] + ","
      elsif str.index(date) == 0 then
        p str[date.length+1..str.length]
        json += date + str[date.length+1..str.length] + ","
      elsif str.index(start_time) == 0 then
        p str[start_time.length+1..str.length]
        json += start_time + str[start_time.length+1..str.length] + ","
      elsif str.index(end_time) == 0 then
        p str[end_time.length+1..str.length]
        json += end_time + str[end_time.length+1..str.length] + ","
      elsif str.index(title) == 0 then
        p str[title.length+1..str.length]
        json += title + str[title.length+1..str.length] + ","
      elsif str.index(subtitle) == 0 then
        p str[subtitle.length+1..str.length]
        json += subtitle + str[subtitle.length+1..str.length] + ","
      elsif str.index(performer) == 0 then
        p str[performer.length+1..str.length]
        json += performer + str[performer.length+1..str.length] + ","
      elsif str.index(subperformer) == 0 then
        p str[subperformer.length+1..str.length]
        json += subperformer + str[subperformer.length+1..str.length] + ","
      elsif str.index(id) == 0 then
        p str[id.length+1..str.length]
        json += id + str[id.length+1..str.length] + ","
      elsif str.index(genre) == 0 then
        p str[genre.length+1..str.length]
        json += genre + str[genre.length+1..str.length] + ","
      elsif str.index(subgenre) == 0 then
        p str[subgenre.length+1..str.length]
        json += subgenre + str[subgenre.length+1..str.length] + ","
      elsif count == tv.each_line.count
        p str[0..str.index(gomi)-1]
        json += "detail:" + str[0..str.index(gomi)-1]
      end
    end
    json += "}"
  end
end
json += "] "

p "JSON =" + json
