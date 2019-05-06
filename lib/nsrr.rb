# frozen_string_literal: true

require "colorize"
require "nsrr/version"

Nsrr::COMMANDS = {
  "c" => :console,
  "d" => :download,
  "u" => :update,
  "v" => :version
}.freeze

# Exposes certain commands for access from the command line.
module Nsrr
  def self.launch(argv)
    send((Nsrr::COMMANDS[argv.first.to_s.scan(/\w/).first] || :help), argv)
  end

  def self.console(argv)
    require "nsrr/commands/console"
    Nsrr::Commands::Console.start(argv)
  end

  def self.download(argv)
    require "nsrr/commands/download"
    Nsrr::Commands::Download.run(argv)
  end

  def self.update(argv)
    require "nsrr/commands/update"
    Nsrr::Commands::Update.start(argv)
  end

  def self.help(_)
    puts <<-EOT

Usage: nsrr COMMAND [ARGS]

The most common nsrr commands are:
  [c]onsole         Load an interactive console to access
                    and download datasets and files
  [d]ownload        Download all or some files in a DATASET
  [u]pdate          Update the nsrr gem
  [v]ersion         Returns the version of nsrr gem

Commands can be referenced by the first letter:
  Ex: `nsrr v`, for version

EOT
    puts "Read more on the download command here:"
    puts "  " + "https://github.com/nsrr/nsrr-gem".colorize(:blue).on_white.underline
    puts "\n"
  end

  def self.version(_)
    puts "Nsrr #{Nsrr::VERSION::STRING}"
  end
end
