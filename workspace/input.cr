print "Enter your name: "
name = gets.chomp

if name.nil?
  name = "Guest"
end

puts "Hello, #{name}!"
