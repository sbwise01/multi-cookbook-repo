require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class VaultConfig < Chef::Resource::LWRPBase
      self.resource_name = 'vault_config'

      # @see https://vaultproject.io/docs/config/index.html
      # TCP Listener options
      attribute(:address, kind_of: String)
      attribute(:cluster_address, kind_of: String)
      attribute(
        :proxy_protocol_behavior,
        equal_to: %i(use_always allow_authorized deny_unauthorized)
      )
      attribute(:proxy_protocol_authorized_addrs, kind_of: String)
      attribute(
        :tls_disable,
        equal_to: [true, false, 1, 0, 'yes', 'no'], default: true
      )
      attribute(:tls_cert_file, kind_of: String)
      attribute(:tls_key_file, kind_of: String)
      attribute(:tls_min_version, kind_of: String)
      attribute(:tls_cipher_suites, kind_of: String)
      attribute(:tls_prefer_server_cipher_suites, kind_of: String)
      attribute(:tls_require_and_verify_client_cert, kind_of: String)
      attribute(:tls_disable_client_cert, kind_of: String)
      attribute(:tls_client_ca_file, kind_of: String)
      # Global options
      attribute(:api_addr, kind_of: String)
      attribute(:cluster_name, kind_of: String)
      attribute(:cache_size, kind_of: Integer)
      attribute(:disable_cache, equal_to: [true, false])
      attribute(:disable_mlock, equal_to: [true, false], default: true)
      attribute(:disable_performance_standby, equal_to: [true, false])
      attribute(:default_lease_ttl, kind_of: String)
      attribute(:max_lease_ttl, kind_of: String)
      attribute(:ui, equal_to: [true, false])

      # Storage options
      attribute(
        :storage_type,
        default: 'inmem',
        equal_to: %w(
          consul
          etcd
          zookeeper
          dynamodb
          s3
          mysql
          postgresql
          inmem
          file
        )
      )
      attribute(:storage_options, kind_of: Hash)
      attribute(:hastorage_type, kind_of: String)
      attribute(:hastorage_options, kind_of: Hash)
      # Telemetry options
      attribute(:telemetry_options, kind_of: Hash)
      # HA options
      attribute(:api_addr, kind_of: String)
      attribute(:cluster_addr, kind_of: String)
      attribute(:disable_clustering, equal_to: [true, false])
      # Seal options
      attribute(:seal_type, kind_of: String)
      attribute(:seal_options, kind_of: Hash)

      def tls?
        if tls_disable == true || tls_disable == 'yes' || tls_disable == 1
          false
        else
          true
        end
      end

      # Transforms the resource into a JSON format which matches the
      # Vault service's configuration format.
      # @see https://vaultproject.io/docs/config/index.html
      def to_json(_opts = {})
        # top-level
        config_keeps = %i(
          api_addr
          cluster_name
          cache_size
          disable_cache
          disable_mlock
          default_lease_ttl
          disable_performance_standby
          max_lease_ttl
          ui
        )
        config = to_hash.keep_if do |k, v|
          config_keeps.include?(k.to_sym) && !v.nil?
        end
        # listener
        listener_keeps = %i(
          address
          cluster_address
          proxy_protocol_behavior
          proxy_protocol_authorized_addrs
        )
        tls_params = %i(
          tls_cert_file
          tls_key_file
          tls_min_version
          tls_cipher_suites
          tls_prefer_server_cipher_suites
          tls_disable_client_cert
          tls_require_and_verify_client_cert
          tls_client_ca_file
        )
        listener_keeps += tls_params if tls?
        listener_options = to_hash.keep_if { |k, v|
          listener_keeps.include?(k.to_sym) && !v.nil?
        }.merge(tls_disable: tls_disable.to_s)
        config['listener'] = { 'tcp' => listener_options }
        # storage
        config['storage'] = { storage_type => (storage_options || {}) }
        # ha_storage, only some storages support HA
        if %w(consul etcd zookeeper dynamodb).include? hastorage_type
          config['ha_storage'] = { hastorage_type => (hastorage_options || {}) }
        end
        unless seal_type.nil?
          config['seal'] = { seal_type => (seal_options || {}) }
        end
        unless telemetry_options.nil? || telemetry_options.empty?
          config['telemetry'] = telemetry_options
        end
        # HA config
        ha_keeps = %i(api_addr cluster_addr disable_clustering)
        config.merge!(
          to_hash.keep_if do |k, v|
            ha_keeps.include?(k.to_sym) && !v.nil?
          end
        )

        JSON.pretty_generate(config, quirks_mode: true)
      end
    end
  end
end
