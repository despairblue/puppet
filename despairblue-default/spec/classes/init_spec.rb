require 'spec_helper'
describe 'default' do

  context 'with defaults for all parameters' do
    it { should contain_class('default') }
  end
end
