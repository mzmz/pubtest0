#module MsgStruct
  require 'pp'
  
  #split a file to items, 
  #using marking regex to match the first line of an item
  #ignore the lines including eliding regex
  def file2items(file, marking, eliding=/^\s*$/)
    items = []
    File.open(file, "r") do |f|
      item = []
      f.each do |line|
        if marking.match(line)
          items << item unless item.empty?
          item = []
          #p line
        end
        item << line unless eliding.match(line)
      end
      items << item  
    end
  end
    
  class Item                  #base class in COMPOSITE pattern
    attr_reader :name
    attr_accessor :value
    def initialize(name, value)
      @name = name
      @value = value
    end
  end
  
  class IdValue
    def initialize(id, value)
      @i_v = {id=>value}
    end
  end
    
  class Message             #composite class in COMPOSITE pattern
    attr_reader :symbol, :info
    attr_accessor :ivs
    def initialize(text_block)
      @tag = []
      @ivs = []        #lines in {id, value} pairs or tags
      @info = []       #log info of distributors
  #2013 Jul 11  13:47:37.941  [00]  0xB0C0  LTE RRC OTA Packet  --  UL_CCCH
  #2013 Jul 22  15:35:50.038  [00]  0xB0ED  LTE NAS EMM Plain OTA Outgoing Message  --  Detach request Msg
      @tag << {"log" => 0}
      inf_msg (text_block.shift)
      text_block.each do |line|
        #p "Msgi-" + line
        if a_os=line.split(',')
          a_os.each do |raw_iv| #@ivs << key_val()
            iv = {}  
            if /(.*)[\:=](.*)/.match(raw_iv)
              iv[$1.strip] = $2.strip
            else           
              #p 'xssss' + raw_iv   
              if raw_iv_spat = raw_iv.split           
                x0 = raw_iv_spat.shift
                iv[x0] = raw_iv_spat.join       
              end
            end
            @ivs << iv
          end
        end
      end
      tag_msg()
      return check_msg()
    end
    
    def key_val(line)
      kv = {}
      if /(.*) = (.*)/.match(line)
        kv[$1] = $2
      else
        kv[line] = ''
      end
    end
    
    def sniff_msg
    end
  
    def inf_msg(line1)
      if /(.*)\[00\]\s*(0x\w{4})\s(.*)/.match(line1)    
        @info << { 'time' => $1, 'qxdm_id' => $2, 'cmt' => $3}
      end
    end
    
    def tag_msg()
    end
    
    def check_msg()
      pp @ivs
      return true
    end
    def nas_msg()   #check with spec
      return true
    end
    def rrc_msg()
      return true
    end
  end

  class MessageFork
    attr_accessor :msg_type, :before, :after
    def initialize(msg_type, before=[], after=[])
      @msg_type = msg_type
      @before = before
      @after = after
    end
  end


log = file2items("ex_log", /\d\d:\d\d:\d\d/)
p log.length
#pp log
p '================================================'
ex_msgs = []
log.each do |item|
  ex_msgs << Message.new(item)
end 

#end
