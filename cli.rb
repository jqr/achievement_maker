require "rubygems"
require "bundler"
Bundler.setup(:default)

require './achievement'

first_line = 'ACHIEVEMENT UNLOCKED'
second_line = 'you created an achievement generator'

achievement(first_line, second_line).write('image.png')

