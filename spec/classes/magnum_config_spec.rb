require 'spec_helper'

describe 'magnum::config' do

  let(:config_hash) do {
    'DEFAULT/foo' => { 'value'  => 'fooValue' },
    'DEFAULT/bar' => { 'value'  => 'barValue' },
    'DEFAULT/baz' => { 'ensure' => 'absent' }
  }
  end

  shared_examples_for 'magnum_config' do
    let :params do
      { :magnum_config => config_hash }
    end

    it 'configures arbitrary magnum-config configurations' do
      is_expected.to contain_magnum_config('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_magnum_config('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_magnum_config('DEFAULT/baz').with_ensure('absent')
    end
  end

  shared_examples_for 'magnum_api_paste_ini' do
    let :params do
      { :magnum_api_paste_ini => config_hash }
    end

    it 'configures arbitrary magnum-config configurations' do
      is_expected.to contain_magnum_api_paste_ini('DEFAULT/foo').with_value('fooValue')
      is_expected.to contain_magnum_api_paste_ini('DEFAULT/bar').with_value('barValue')
      is_expected.to contain_magnum_api_paste_ini('DEFAULT/baz').with_ensure('absent')
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum_config'
      it_configures 'magnum_api_paste_ini'
    end
  end
end
