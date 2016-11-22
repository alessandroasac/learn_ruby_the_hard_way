# Get the filena name passed as parameter from command line
filename = ARGV.first

# Open the file: the file object is created
txt = open(filename)

# Reading the file content
puts "Here's your file #{filename}:"
print txt.read

txt.close

# Asking the file name again
print 'Type the filename again: '
file_again = $stdin.gets.chomp

# Openning the file again
txt_again = open(file_again)

# Read the file again
print txt_again.read

txt_again.close
