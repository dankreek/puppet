test_name "ZPool: configuration"
confine :to, :platform => 'solaris'

require 'puppet/acceptance/solaris_util'
extend Puppet::Acceptance::ZPoolUtils

teardown do
  step "ZPool: cleanup"
  agents.each do |agent|
    clean agent
  end
end


agents.each do |agent|
  skip_test "not enough drive space on our solaris10 machines" if agent['platform'] =~ /solaris-10/
  step "ZPool: setup"
  setup agent
  #-----------------------------------
  step "ZPool: ensure create"
  apply_manifest_on(agent, "zpool{ tstpool: ensure=>present, disk=>'/ztstpool/dsk1' }") do
    assert_match( /ensure: created/, result.stdout, "err: #{agent}")
  end
  on(agent, "zpool list") do
    assert_match( /tstpool/, result.stdout, "err: #{agent}")
  end
end
