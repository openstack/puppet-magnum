require 'spec_helper'

describe 'magnum::x509' do

  shared_examples 'magnum::x509' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it { is_expected.to contain_magnum_config('x509/allow_ca').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('x509/allowed_extensions').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('x509/allowed_key_usage').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('x509/term_of_validity').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_magnum_config('x509/rsa_key_size').with_value('<SERVICE DEFAULT>') }
    end

    context 'with specific parameters' do
      let :params do
        { :allow_ca           => true,
          :allowed_extensions => ['keyUsage', 'extendedKeyUsage'],
          :allowed_key_usage  => ['Digital Signature', 'Non Repudiation'],
          :term_of_validity   => 3650,
          :rsa_key_size       => 4096,
        }
      end

      it { is_expected.to contain_magnum_config('x509/allow_ca').with_value(true) }
      it { is_expected.to contain_magnum_config('x509/allowed_extensions').with_value('keyUsage,extendedKeyUsage') }
      it { is_expected.to contain_magnum_config('x509/allowed_key_usage').with_value('Digital Signature,Non Repudiation') }
      it { is_expected.to contain_magnum_config('x509/term_of_validity').with_value(3650) }
      it { is_expected.to contain_magnum_config('x509/rsa_key_size').with_value(4096) }
    end
  end

  on_supported_os({
    :supported_os   => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'magnum::x509'
    end
  end
end
