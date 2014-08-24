require 'spec_helper'
describe 'autoupdate' do

  context 'with defaults for all parameters' do
    it { should contain_class('autoupdate') }
  end
end
