#require './struct.rb'
require 'pp'

##split asn file to blocks
items = []
#cnt = 0
File.open("36331-c00-asn", "r") do |f|
  item = []
  f.each do |line|
    if /::=/.match(line)
      items << item
      item = []
      #p cnt += 1
    end
    item << line #until /^--/.match(line) #or line==nil
  end
end


msgs = {}
items.each do |item|
  if /(.*)::=(.*)/.match(item[0])
    msg_key = $1.strip
    msgs[msg_key] = []
    item[0] = $2
    item.each do |line|
      if a_os=line.split(',')
        a_os.each do |a_pair|
          if a_pair.split.length != 0
            msgs[msg_key] << a_pair.split
          end
        end
      end
    end    
  end
end

pp msgs



