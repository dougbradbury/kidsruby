real_stdout = STDOUT
require 'seeing_is_believing/result'
$seeing_is_believing_current_result = SeeingIsBelieving::Result.new

at_exit do
  $seeing_is_believing_current_result.stdout = ''
  $seeing_is_believing_current_result.stderr = ''

  real_stdout.write Marshal.dump $seeing_is_believing_current_result
end
