print 'How old are you? '
age = gets.chomp
print 'How tall are you? '
height = gets.chomp
print 'how much do you weigh? '
weight = gets.chomp

puts "So, you're #{age} old, #{height} tall and #{weight} heavy."

#####################

# chomp(separator=$/) -> new_str
# Returns a **new** String with the given record separator removed from the end
# of str (if present). If $/ has not been changed from the default Ruby record
# separator, then chomp also removes carriage return characters (that is it will
# remove \n, \r, and \r\n). If $/ is an empty string, it will remove all
# trailing newlines from the string.

puts "'hello'.chomp('llo') = #{'hello'.chomp('llo')}"
