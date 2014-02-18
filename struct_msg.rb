#require './MsgStruct.rb'
def file2items(file, marking, eliding=/^\s*$/)
  items = []
  File.open(file, "r") do |f|
    item = []
    f.each do |line|
      if marking.match(line)
        items << item
        item = []
        #p line
      end
      item << line unless eliding.match(line)
    end
    items << item  
  end
end

#split every item to {key, content[, info]} structure

#split spec asn1 items to message {key, content} pair
def ts2msgs(keg)
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



require 'pp'




##split asn file to blocks
items = file2items("36331-c00-asn", /::=/)





#pp msgs
p msgs.length



#15:35:50.038  [00] 
#pp 
log = file2items("ex_log", /\d\d:\d\d:\d\d/)
p log.length

log.each do |alog|
  alog.each do |line|
    if line.include(    #message tag
        
