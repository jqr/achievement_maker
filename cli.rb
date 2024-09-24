require "rubygems"
require "bundler"
Bundler.setup(:default)

require_relative "./achievement"

first_line = "ACHIEVEMENT UNLOCKED"
second_line = "you created an achievement generator"

achievement(first_line, second_line, email: "elijah.miller@gmail.com").write("image.png")
