module Roblox
  module Nomad
    module Helpers

      def nomad_binary_name(node, version)
        os = node['os']
        case node['kernel']['machine']
          when 'x86_64', 'amd64' then
            ['nomad', version, os, 'amd64'].join('_')
          when /i\d86/ then
            ['nomad', version, os, '386'].join('_')
          when /^arm64/ then
            ['nomad', version, os, 'arm'].join('_')
          when /^arm/ then
            ['nomad', version, os, 'arm'].join('_')
          else
            ['nomad', version, os, node['kernel']['machine']].join('_')
        end.concat('.zip')
      end

      def nomad_validation_name(version)
        ['nomad', version, 'SHA256SUMS'].join('_')
      end

      def nomad_validation_sig_name(version)
        ['nomad', version, 'SHA256SUMS.sig'].join('_')
      end
    end
  end
end

Chef::Recipe.send(:include, Roblox::Nomad::Helpers)
Chef::Resource.send(:include, Roblox::Nomad::Helpers)
Chef::Provider.send(:include, Roblox::Nomad::Helpers)
