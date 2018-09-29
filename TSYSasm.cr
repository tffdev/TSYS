class Parser
  @@output = ""
  @@line = 0
  @@cur_width = 0
  def self.run_parser
    if ARGV.size >= 2 
      data = File.read(ARGV[0])
      parse_asm(data)
    else
      puts "Not enough arguments, make arg an TASM file"
    end
  end

  def self.parse_asm(content)
    command_list = [] of String  
    content.scan(/([a-z0-9]+)/).each do |res|
      command_list << res[0]
    end
    command_list = command_list.reverse
    while command_list.size > 0
      @@line += 1 
      instr = command_list.pop
      case instr
      when "add"
        output_expect_num("1", instr, command_list)
      when "sub"
        output_expect_num("2", instr, command_list)
      when "inc"
        append_to_out "300"
      when "jmp"
        output_expect_num("4", instr, command_list)
      when "jiz"
        output_expect_num("5", instr, command_list)
      when "jip"
        output_expect_num("6", instr, command_list)
      when "get"
        output_expect_num("7", instr, command_list)
      when "put"
        output_expect_num("8", instr, command_list)
      when "prt"
        append_to_out "900"
      when "aml"
        output_expect_num("a", instr, command_list)
      when "sml"
        output_expect_num("b", instr, command_list)
      when "hlt"
        append_to_out "f00"
      else 
        puts "[!!!!] Invalid instruction `" + instr + "`, line " + @@line.to_s
        Process.exit
      end 
    end
    @@output
  end

  def self.output_expect_num(opcode, instr, command_list)
    if command_list.size > 0
      if int_to_add = command_list.pop.to_i
        str = opcode
        str += "0" if (int_to_add < 10)
        str += to_hex(int_to_add)
        append_to_out(str)
      else
        puts "[!!!!] Expecting number/address after `" + instr + "`, line " + @@line.to_s
        Process.exit
      end
    else
      puts "[!!!!] Expecting number/address after `" + instr + "`, line " + @@line.to_s
      Process.exit
    end
  end

  def self.append_to_out(string)
    @@cur_width += 1
    if(@@cur_width >= 5)
      @@cur_width = 0
      @@output += string + "\n"
    else
      @@output += string + " "
    end
  end

  def self.to_hex(decimal)
    decimal_remainder = decimal % 16
    hexchars = "0123456789abcdef"
    div = decimal / 16
    if div == 0
      hexchars[decimal_remainder].to_s
    else
      to_hex(div) + hexchars[decimal_remainder].to_s
    end
  end
end

result = Parser.run_parser
if res = result
  File.write(ARGV[1], "v2.0 raw\n" + res || "")
end