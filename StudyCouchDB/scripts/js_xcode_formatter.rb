

$PROCESS_FILE="./output.txt"

def default_file_to_modify
    file = File.open($PROCESS_FILE, "rb")
    contents = file.read
    file.close
    return contents
end

def wrap_js_line_with_quotes(text)
    content = []
    text.each_line do |l|
        next if l=~ /^\s*$/
        d = l.sub(/^\s*/) {|m| m + "\""}.sub(/\s*\n*$/) {|m| "\""+m }
        content << d 
    end
    return content.join("")
end

def unwrap_js_line_with_quotes(text)
    content = []
    text.each_line do |l|
        d = l.sub(/^(\s*)\"/) {|m| $1 }.sub(/\"(\s*\n*)$/) {|m| $1 }
        content << d 
    end
    return content.join("")
end


def quote(text=default_file_to_modify)
  t = wrap_js_line_with_quotes(text)
  File.open($PROCESS_FILE, "w") do |f|
     f.puts t 
  end
  puts "Added quotes to each line."
end

def unquote(text=default_file_to_modify)
   t = unwrap_js_line_with_quotes(text)
   File.open($PROCESS_FILE, "w") do |f|
   f.puts t 
   end
   puts "Removed quotes to each line."
end

