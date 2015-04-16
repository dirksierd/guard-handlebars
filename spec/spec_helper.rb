require 'rspec'
require 'guard/compat/test/helper'
require 'guard/handlebars'
require 'byebug'


RSpec.configure do |config|
  config.color = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    ENV["GUARD_ENV"] = 'test'
    @project_path = Pathname.new(File.expand_path('../../', __FILE__))

    allow(Guard::Compat::UI).to receive(:info)
    allow(Guard::Compat::UI).to receive(:debug)
    allow(Guard::Compat::UI).to receive(:error)
    allow(Guard::Compat::UI).to receive(:warning)
    allow(Guard::Compat::UI).to receive(:color_enabled?).and_return(true)
  end

  config.after(:each) do
    ENV["GUARD_ENV"] = nil
  end

end
