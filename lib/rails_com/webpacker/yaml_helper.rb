# make old config/webpacker.yml as an template file, rename it to config/webpacker_template.yml
# ignore config/webpacker.yml in git
module Webpacker
  class YamlHelper

    def initialize(template: 'config/webpacker_template.yml', export: 'config/webpacker.yml')
      template_path = Rails.root + template
      export_path = Rails.root + export
      
      @yaml = YAML.parse_stream File.read(template_path)
      @content = @yaml.children[0].children[0].children
      @parsed = @yaml.to_ruby[0]
      @io = File.new(export_path, 'w+')
    end
    
    def dump
      @yaml.yaml @io
      @io.fsync
      @io.close
    end
    
    def append(env = 'default', key, value)
      return if Array(@parsed.dig(env, key)).include? value
      env_index = @content.find_index { |i| i.scalar? && i.value == env }

      env_content = @content[env_index + 1].children
      key_index = env_content.find_index { |i| i.scalar? && i.value == key }
      
      value_content = env_content[key_index + 1]
      if value_content.sequence?
        value_content.style = 1  # block style
        value_content.children << Psych::Nodes::Scalar.new(value)
      end

      value_content
    end
    
  end
end
