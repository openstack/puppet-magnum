require 'spec_helper'

describe 'magnum::clients' do

  shared_examples 'magnum::clients' do

    it 'contains following classes' do
      is_expected.to contain_class('magnum::deps')
      is_expected.to contain_class('magnum::params')
      is_expected.to contain_class('magnum::clients::barbican')
      is_expected.to contain_class('magnum::clients::cinder')
      is_expected.to contain_class('magnum::clients::glance')
      is_expected.to contain_class('magnum::clients::heat')
      is_expected.to contain_class('magnum::clients::nova')
      is_expected.to contain_class('magnum::clients::magnum')
      is_expected.to contain_class('magnum::clients::neutron')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::clients'
    end
  end
end
