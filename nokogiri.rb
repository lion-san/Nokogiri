# encoding: UTF-8
require 'nokogiri'
require 'open-uri'
require 'json'


p "てすと"

#Delay
delay = 0.5 #Second

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

#Proxy
proxy = ["http://rep.proxy.nic.fujitsu.com:8080", "github", "1234567890"]
 
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

#html = open(url)
html = open(url,{:proxy_http_basic_authentication => proxy})
doc = Nokogiri::HTML(html)

puts doc.css('a').length

json = "{ \"date\":" + "\"" + today + "\","
json += "\"region\":" + "\"" + "東京" + "\","
json += "\"region_cd\":" + "\"" + "23" + "\","
json += "\"channels\" : [ "

catch(:exit) {

  test = 0
doc.css('a').each do |item|
  if /^\/iepg.tvpi/ =~ item[:href] then
    test += 1
    puts host+item[:href]
    #iepg = open(host+item[:href])
    iepg = open(host+item[:href], {:proxy_http_basic_authentication => proxy})

    #Delay
    sleep(delay)

    tv_sjis = Nokogiri::HTML.parse(iepg, nil, "Shift_JIS")
    
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
        json += "\"" + station[0..station.length-2] + "\":\"" + str[station.length+1..str.length] + "\","
      elsif str.index(station_name) == 0 then
        p str[station_name.length+1..str.length]
        json += "\"" + station_name[0..station_name.length-2] + "\":\"" + str[station_name.length+1..str.length] + "\","
      elsif str.index(year) == 0 then
        p str[year.length+1..str.length]
        json += "\"" + year[0..year.length-2] + "\":\"" + str[year.length+1..str.length] + "\","
      elsif str.index(month) == 0 then
        p str[month.length+1..str.length]
        json += "\"" + month[0..month.length-2] + "\":\"" + str[month.length+1..str.length] + "\","
      elsif str.index(date) == 0 then
        p str[date.length+1..str.length]
        json += "\"" + date[0..date.length-2] + "\":\"" + str[date.length+1..str.length] + "\","
      elsif str.index(start_time) == 0 then
        p str[start_time.length+1..str.length]
        json += "\"" + start_time[0..start_time.length-2] + "\":\"" + str[start_time.length+1..str.length] + "\","
      elsif str.index(end_time) == 0 then
        p str[end_time.length+1..str.length]
        json += "\"" + end_time[0..end_time.length-2] + "\":\"" + str[end_time.length+1..str.length] + "\","
      elsif str.index(title) == 0 then
        p str[title.length+1..str.length]
        json += "\"" + title[0..title.length-2] + "\":\"" + str[title.length+1..str.length] + "\","
      elsif str.index(subtitle) == 0 then
        p str[subtitle.length+1..str.length]
        json += "\"" + subtitle[0..subtitle.length-2] + "\":\"" + str[subtitle.length+1..str.length] + "\","
      elsif str.index(performer) == 0 then
        p str[performer.length+1..str.length]
        json += "\"" + performer[0..performer.length-2] + "\":\"" + str[performer.length+1..str.length] + "\","
      elsif str.index(subperformer) == 0 then
        p str[subperformer.length+1..str.length]
        json += "\"" + subperformer[0..subperformer.length-2] + "\":\"" + str[subperformer.length+1..str.length] + "\","
      elsif str.index(id) == 0 then
        p str[id.length+1..str.length]
        json += "\"" + id[0..id.length-2] + "\":\"" + str[id.length+1..str.length] + "\","
      elsif str.index(genre) == 0 then
        p str[genre.length+1..str.length]
        json += "\"" + genre[0..genre.length-2] + "\":\"" + str[genre.length+1..str.length] + "\","
      elsif str.index(subgenre) == 0 then
        p str[subgenre.length+1..str.length]
        json += "\"" + subgenre[0..subgenre.length-2] + "\":\"" + str[subgenre.length+1..str.length] + "\","
      elsif count == tv.each_line.count
        p str[0..str.index(gomi)-1]
        json += "\"" + "detail\":" + "\"" + str[0..str.index(gomi)-1] + "\""
      end
    end
    json += "},"
    throw :exit if test >= 3
  end
end
}

json = json[0..json.length-2]
json += " ] "
json += " } "
#p "JSON =" + json

result = JSON.parse(json)
puts result
