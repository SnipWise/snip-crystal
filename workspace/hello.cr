require "io

begin
  puts "Please enter your name:"
  input = gets.chomp
  if input
    puts "Hello, #{input}!"
  else
    puts "No input provided."
  end
rescue StandardError
  puts "An error occurred while reading input."
end
