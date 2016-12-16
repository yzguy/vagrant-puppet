require 'erb'
require 'yaml'

# Load Configuration from YAML
config = YAML.load_file 'config.yml'

task default: 'setup'

desc 'Generate Answers File'
task :generate_answer_file do
  # Answer File and ERB Template
  answer_file = config[:puppet][:answer_file]
  answer_file_template = answer_file + '.erb'

  # Variables
  @master   = config[:master]
  @password = config[:puppet][:password]

  # Read ERB Template, write out rendered file
  File.open(answer_file_template, 'r') { |f| @erb_template = ERB.new(f.read) }
  File.open(answer_file, 'w') { |f| f.write(@erb_template.result) }
end

desc 'Generate Puppet Manifest'
task :generate_puppet_manifest do
  # Answer File and ERB Template
  manifest_file = config[:puppet][:manifests_path] + '/default.pp'
  manifest_file_template = manifest_file + '.erb'

  # Variables
  @master = config[:master]
  @node1  = config[:node1]
  @node2  = config[:node2]
  @node3  = config[:node3]
  @r10k   = config[:r10k]

  # Read ERB Template, write out rendered file
  File.open(manifest_file_template, 'r') { |f| @erb_template = ERB.new(f.read) }
  File.open(manifest_file, 'w') { |f| f.write(@erb_template.result) }
end

desc 'Set up SSH Keys'
task :setup_ssh_keys do
  ssh_dir = ENV['HOME'] + '/.ssh/'
  ssh_private_key = ssh_dir + 'id_rsa'
  ssh_public_key = ssh_dir + 'id_rsa.pub'
  ssh_known_hosts = ssh_dir + 'known_hosts'
  module_path = config[:puppet][:module_path]

  [ssh_private_key, ssh_public_key, ssh_known_hosts].each do |f|
    FileUtils.cp f, module_path + '/ssh_keys/files/' if File.exist?(f)
  end
end

desc 'Run Setup Tasks'
task setup: [
  :generate_answer_file, :generate_puppet_manifest, :setup_ssh_keys
]
