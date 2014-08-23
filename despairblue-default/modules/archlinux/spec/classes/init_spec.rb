require 'spec_helper'
describe 'archlinux' do

  context 'with defaults for all parameters' do
    it { should contain_class('archlinux') }
  end
end
