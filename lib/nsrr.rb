require "nsrr/version"

Nsrr::COMMANDS = {
  'v' => :version
}

module Nsrr
  def self.launch(argv)
    self.send((Nsrr::COMMANDS[argv.first.to_s.scan(/\w/).first] || :help), argv)
  end

  def self.help(argv)
    puts <<-EOT

Usage: nsrr COMMAND [ARGS]

The most common nsrr commands are:
  [v]ersion         Returns the version of nsrr gem

Commands can be referenced by the first letter:
  Ex: `nsrr v`, for version

EOT
  end

  def self.version(argv)
    puts "Nsrr #{Nsrr::VERSION::STRING}"
  end

end
