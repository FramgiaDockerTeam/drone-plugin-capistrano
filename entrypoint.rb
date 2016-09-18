require "json"
require "open3"

arguments = ARGV[1] ? ARGV[1] : '[]'
arguments = JSON.parse(arguments);

`mkdir ~/.ssh`

if arguments['workspace']
    Dir.chdir arguments['workspace']['path']
    key = arguments['workspace']['keys']['private']
    `echo "#{key}" > ~/.ssh/id_rsa`
end

`chmod -R 600 ~/.ssh`

vargs = arguments['vargs'];
commands = vargs['commands'] ? vargs['commands'] : [];
commands.each do |command|
    puts "[+] " + command
    Open3.popen2e("bash", "-c", command) do |stdin, stdout_and_stderr, wait_thr|
        stdout_and_stderr.each { |line| puts line }
        exit 1 unless wait_thr.value.success?
    end
end
