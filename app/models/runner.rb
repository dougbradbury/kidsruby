require 'seeing_is_believing'

class Runner < Qt::Process
  attr_writer :results

  def results
    @results
  end

  signals 'seeingFinished()'

  def initialize(main)
    super
    @main_widget = main


    connect(self, SIGNAL('seeingFinished()'),
        @main_widget, SLOT('runnerFinished()'))
  end

  # deleteme
  def debug(string)
    File.open('/Users/dougbradbury/Projects/kidsruby/debug.output', 'a') { |f| f.puts string }
  end

  def run(code = default_code, code_file_name = default_kid_code_location)
    @thread.kill if (@thread && @thread.alive?)
    # save_kid_code(code, code_file_name)
    @thread = Thread.new do
      begin
      matrix_filename = File.expand_path('../../../lib/kidsruby/the_matrix', __FILE__)
      @results = SeeingIsBelieving.call(build_code_from_fragment(code),
                                        filename: code_file_name,
                                        matrix_filename: matrix_filename,
                                        encoding: 'u',
    #                                     require:  [(File.expand_path(File.dirname(__FILE__) + "/../../lib/kidsruby"))]
                                       )
      seeingFinished()
      rescue Exception => e
        debug(e.message)
        debug(e.backtrace.join("\n"))
      end

    end
  end

  def stop
    @thread.kill if (@thread && @thread.alive?)
  end

  def save_kid_code(code, code_file_name)
    codeFile = Qt::File.new(code_file_name)
    if !codeFile.open(Qt::File::WriteOnly | Qt::File::Text)
        Qt::MessageBox::warning(self, tr("KidsRuby Problem"),
                               tr("Oh, uh! Cannot write file %s:\n%s" %
                               [ codeFile.fileName(), codeFile.errorString() ] ) )
        return
    end

    codeFile.write(build_code_from_fragment(code))
    codeFile.close()
  end

  def build_code_from_fragment(code)
    # add any default requires for kid code
    new_code = "require '" + File.expand_path(File.dirname(__FILE__) + "/../../lib/kidsruby") + "'\n"
    new_code << code
    new_code
    code
  end

  def default_code
    'puts "No code entered"'
  end

  def default_kid_code_location
    "#{tmp_dir}/kidcode.rb"
  end

  def tmp_dir
    Qt::Dir::tempPath
  end
end
