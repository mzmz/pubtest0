#require './struct.rb'
require 'pp'

items = []
cnt = 0
File.open("36331-c00-asn", "r") do |f|
  item = []
  f.each do |line|
    if /::=/.match(line)
      items << item
      item = []
      p cnt += 1
    end
    item << line #until /^--/.match(line) #or line==nil
  end
end


msgs = {}

items.each do |item|
  if /(.*-Message)\s*::=(.*)/.match(item[0])
    msgs[$1] = item 
  end
end

pp msgs
