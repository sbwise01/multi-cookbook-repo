#
# Cookbook:: rblx_nomad
# Recipe:: service_nomad_systemd
#
# Copyright:: 2019, Roblox, All Rights Reserved.

systemd_unit 'nomad.service' do
  content <<-SERVICE.gsub(/^\s+/, '')
  [Unit]
  Description="HashiCorp Nomad - An application and service scheduler"
  Documentation=https://www.nomad.io/docs/
    Requires=network-online.target
  After=network-online.target
  ConditionFileNotEmpty=/etc/nomad/nomad.hcl

  [Service]
  User=nomad
  Group=nomad
  ExecStart=/usr/local/bin/nomad agent -config=/etc/nomad/
    ExecReload=/bin/kill --signal HUP $MAINPID
  KillMode=process
  Restart=on-failure
  RestartSec=2
  StartLimitBurst=3
  StartLimitIntervalSec=10
  LimitNOFILE=65536
  OOMScoreAdjust=-800

  [Install]
  WantedBy=multi-user.target
  SERVICE

  action %i[create enable]
end

# TODO: start service?
