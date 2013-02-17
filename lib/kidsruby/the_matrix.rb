real_stdout = STDOUT
require 'seeing_is_believing/result'
$seeing_is_believing_current_result = SeeingIsBelieving::Result.new

at_exit do
  result = $seeing_is_believing_current_result
  result.stdout = ''
  result.stderr = ''
  result.exception = $! if $!

  real_stdout.write Marshal.dump $seeing_is_believing_current_result
end
