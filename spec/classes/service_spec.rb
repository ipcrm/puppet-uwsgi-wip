require 'spec_helper'

describe 'uwsgi::service' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:hiera_config) { 'hiera.yaml' }
      let(:pre_condition) { 'file {"/etc/uwsgi.ini": ensure => present}' }

      context 'without parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('uwsgi::service') }
        it { is_expected.to contain_service('uwsgi') }

        case facts[:osfamily]
        when 'Debian'
          case facts[:operatingsystemmajrelease]
          when '7', '14.04'
            it { is_expected.to contain_file('/etc/init/uwsgi.conf') }
          else
            it { is_expected.to contain_file('/etc/systemd/system/uwsgi.service') }
          end
        when 'RedHat'
          case facts[:operatingsystemmajrelease]
          when '6'
            it { is_expected.to contain_file('/etc/init.d/uwsgi') }
          else
            it { is_expected.to contain_file('/etc/systemd/system/uwsgi.service') }
          end
        end
      end
    end
  end
end