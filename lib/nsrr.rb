require "nsrr/version"

Nsrr::COMMANDS = {
  'c' => :console,
  'v' => :version
}

module Nsrr
  def self.launch(argv)
    self.send((Nsrr::COMMANDS[argv.first.to_s.scan(/\w/).first] || :help), argv)
  end

  def self.console(argv)
    require 'nsrr/commands/console'
    Nsrr::Commands::Console.start(argv)
    # console = Nsrr::Commands::Console.new(argv)
    # console.start
    # `#{File.expand_path('../', __FILE__)}/nsrr/commands/console2`


    # require 'irb'
    # require 'irb/completion'
    # IRB.setup nil
    # IRB.conf[:MAIN_CONTEXT] = IRB::Irb.new.context
    # require 'irb/ext/multi-irb'
    # IRB.irb nil, self

    # require 'irb'
    # ARGV.clear
    # @a = "hello"
    # IRB.start

  end

  def self.help(argv)
    puts <<-EOT

Usage: nsrr COMMAND [ARGS]

The most common nsrr commands are:
  [c]onsole         Load an interactive console to access
                    and download datasets and files
  [v]ersion         Returns the version of nsrr gem

Commands can be referenced by the first letter:
  Ex: `nsrr v`, for version

EOT
  end

  def self.version(argv)
    puts "Nsrr #{Nsrr::VERSION::STRING}"
  end

end
