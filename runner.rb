require "coffee-script"
require "mongo"

db_name     = ARGV[0]
input_name  = ARGV[1]
job_name    = ARGV[2]
output_name = ARGV[3]

if output_name
  options = { :out => output_name }
else
  options = { :out => { :inline => true }, :raw => true }
end

job_coffeescript = File.read("jobs/#{db_name}/#{input_name}/#{job_name}.coffee")
job_javascript   = CoffeeScript.compile job_coffeescript, :bare => true
job_functions    = job_javascript.split("\n\n")

job_functions.map! { |j| j.gsub /^\s|\s$/,"" }
# job_functions.map! { |j| j.gsub /^\(|\)\;$/,"" }

mapper    = job_functions[0]
reducer   = job_functions[1]
finalizer = job_functions[2]

puts "DB: #{db_name}"
puts "  In: #{input_name}"
puts "  Out: #{output_name}" if output_name
puts "\n"
puts "Mapper = #{mapper}\n\n"
puts "Reducer = #{reducer}\n\n"
puts "Finalizer = #{finalizer}\n\n" if finalizer

puts "Connecting..."
connection = Mongo::Connection.new
db = connection[db_name]
input = db[input_name]

puts "Running...\n\n"
reply = input.map_reduce mapper, reducer, options

if options[:out].is_a? Hash
  puts "Results: #{reply['results']}\n\n"
  reply.delete('results')
else
  puts "Results: #{db[output_name].find.to_a}"
end
