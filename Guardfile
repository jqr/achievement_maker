# Prints command before running it. Exception on non-zero exit status.
def nice_system(*cmd)
  joined_cmd = Shellwords.join(cmd)
  puts joined_cmd
  system(joined_cmd) || raise("ERORR!")
end

Dir.chdir(File.dirname(__FILE__))
guard :shell do
  watch /.*\.rb/ do |m|
    nice_system("./bin/achievement-maker", "Blah #{rand(1_000_000)}", "--scale", "2", "--email", "elijah.miller@gmail.com", "--player", "0")
  end
end
