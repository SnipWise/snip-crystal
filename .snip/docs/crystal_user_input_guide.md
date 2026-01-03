# User Input and Prompts in Crystal

A practical guide to handling user input in the Crystal programming language.

## Basic Input with `gets`

The simplest way to read user input is using the `gets` method, which reads a line from standard input.

```crystal
print "Enter your name: "
name = gets

puts "Hello, #{name}!"
```

> **Note:** `gets` returns `String?` (a nilable string), so the value can be `nil` if input is unavailable.

## Handling Nil Values

Since `gets` can return `nil`, you should handle this case explicitly.

### Using `gets.not_nil!`

```crystal
print "Enter your age: "
age = gets.not_nil!

puts "You are #{age} years old."
```

### Using a Default Value with `||`

```crystal
print "Enter your city: "
city = gets || "Unknown"

puts "You live in #{city}."
```

### Using `if let` Pattern

```crystal
print "Enter a number: "
if input = gets
  puts "You entered: #{input}"
else
  puts "No input received."
end
```

## Stripping Whitespace

User input often includes a trailing newline. Use `chomp` to remove it.

```crystal
print "Enter your username: "
username = gets.try(&.chomp) || ""

puts "Username: '#{username}'"
```

Or more concisely:

```crystal
print "Enter your username: "
username = gets.not_nil!.chomp

puts "Username: '#{username}'"
```

## Converting Input to Other Types

### String to Integer

```crystal
print "Enter a number: "
input = gets.not_nil!.chomp
number = input.to_i

puts "Double of #{number} is #{number * 2}"
```

### Safe Conversion with `to_i?`

```crystal
print "Enter a number: "
input = gets.not_nil!.chomp

if number = input.to_i?
  puts "You entered the number #{number}"
else
  puts "That's not a valid integer!"
end
```

### String to Float

```crystal
print "Enter a decimal number: "
input = gets.not_nil!.chomp

if value = input.to_f?
  puts "The value is #{value}"
else
  puts "Invalid decimal number."
end
```

## Reading Multiple Values

### Multiple Inputs on Separate Lines

```crystal
print "First name: "
first_name = gets.not_nil!.chomp

print "Last name: "
last_name = gets.not_nil!.chomp

puts "Full name: #{first_name} #{last_name}"
```

### Multiple Values on a Single Line (Space-Separated)

```crystal
print "Enter two numbers separated by space: "
input = gets.not_nil!.chomp
parts = input.split

a = parts[0].to_i
b = parts[1].to_i

puts "Sum: #{a + b}"
```

## Creating a Reusable Prompt Function

```crystal
def prompt(message : String) : String
  print message
  gets.not_nil!.chomp
end

name = prompt("What is your name? ")
age = prompt("How old are you? ").to_i

puts "#{name} is #{age} years old."
```

## Prompt with Validation

```crystal
def prompt_int(message : String) : Int32
  loop do
    print message
    input = gets.not_nil!.chomp
    
    if value = input.to_i?
      return value
    else
      puts "Please enter a valid integer."
    end
  end
end

age = prompt_int("Enter your age: ")
puts "Your age is #{age}"
```

## Yes/No Confirmation Prompt

```crystal
def confirm(message : String) : Bool
  loop do
    print "#{message} (y/n): "
    input = gets.not_nil!.chomp.downcase
    
    case input
    when "y", "yes"
      return true
    when "n", "no"
      return false
    else
      puts "Please answer 'y' or 'n'."
    end
  end
end

if confirm("Do you want to continue?")
  puts "Continuing..."
else
  puts "Aborted."
end
```

## Menu Selection Prompt

```crystal
def menu_select(options : Array(String)) : Int32
  loop do
    options.each_with_index do |option, index|
      puts "#{index + 1}. #{option}"
    end
    
    print "Select an option: "
    input = gets.not_nil!.chomp
    
    if choice = input.to_i?
      if choice >= 1 && choice <= options.size
        return choice
      end
    end
    
    puts "Invalid selection. Please try again.\n"
  end
end

options = ["Start Game", "Load Game", "Settings", "Exit"]
choice = menu_select(options)

puts "You selected: #{options[choice - 1]}"
```

## Password Input (Hidden)

For password input, you can use the `term` shard or system calls. Here's a basic approach:

```crystal
def prompt_password(message : String) : String
  print message
  
  # Disable echo (Unix-like systems)
  system("stty -echo")
  password = gets.not_nil!.chomp
  system("stty echo")
  
  puts "" # New line after hidden input
  password
end

password = prompt_password("Enter password: ")
puts "Password length: #{password.size}"
```

## Reading from STDIN Directly

```crystal
# Read all input at once
print "Enter text (Ctrl+D to finish):\n"
content = STDIN.gets_to_end

puts "You entered #{content.lines.size} lines."
```

## Reading Input with a Timeout

Using fibers and channels:

```crystal
def prompt_with_timeout(message : String, seconds : Int32) : String?
  print message
  
  channel = Channel(String?).new
  
  spawn do
    channel.send(gets.try(&.chomp))
  end
  
  select
  when result = channel.receive
    result
  when timeout(seconds.seconds)
    puts "\nTimeout!"
    nil
  end
end

if input = prompt_with_timeout("Quick! Enter something: ", 5)
  puts "You entered: #{input}"
else
  puts "Too slow!"
end
```

## Summary

| Method | Returns | Use Case |
|--------|---------|----------|
| `gets` | `String?` | Basic input, may be nil |
| `gets.not_nil!` | `String` | When input is guaranteed |
| `gets.try(&.chomp)` | `String?` | Safe trimming |
| `gets.not_nil!.chomp` | `String` | Trimmed guaranteed input |
| `STDIN.gets_to_end` | `String` | Read all input |

Remember to always handle the nilable nature of `gets` and validate user input before converting to other types.
