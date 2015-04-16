require 'spec_helper'

describe Guard::Handlebars do

  before do
    Guard::Handlebars::Inspector.stub(:clean)
    Guard::Handlebars::Runner.stub(:run)
  end

  describe '#initialize' do
    context 'when no options are provided' do
      let(:guard) { Guard::Handlebars.new }

      it 'sets a default :wrap option' do
        guard.options[:bare].should be false
      end

      it 'sets a default :shallow option' do
        guard.options[:shallow].should be false
      end

      it 'sets a default :hide_success option' do
        guard.options[:hide_success].should be false
      end

      it 'sets a default :compiled_name option' do
        guard.options[:compiled_name].should == 'compiled.js'
      end
    end

    context 'with other options than the default ones' do
      let(:guard) { Guard::Handlebars.new({ :output => 'output_directory', :compiled_name => 'templates.js', :bare => true, :shallow => true, :hide_success => true }) }

      it 'sets the provided :bare option' do
        guard.options[:bare].should be true
      end

      it 'sets the provided :shallow option' do
        guard.options[:shallow].should be true
      end

      it 'sets the provided :hide_success option' do
        guard.options[:hide_success].should be true
      end

      it 'sets the provided :compiled_name option' do
        guard.options[:compiled_name].should == 'templates.js'
      end
    end

    context 'with a input option' do
      let(:guard) { Guard::Handlebars.new({ :input => 'app/templates' }) }

      it 'creates a an additional pattern' do
        expect(guard.patterns.size).to eq(2)
      end

      it 'watches all *.handlebars files' do
        guard.patterns.last.should eql %r{app/templates/(.+\.handlebars)}
      end
    end
  end

  describe '.run_all' do
    let(:guard) { Guard::Handlebars.new({patterns: [%r{^x/(.*)\.handlebars}]}) }

    before do
      Dir.stub(:glob).and_return ['x/a.handlebars', 'x/b.handlebars', 'y/c.handlebars']
    end

    it 'runs the run_on_modifications with all watched Handlebars' do
      guard.should_receive(:run_on_modifications).with(['x/a.handlebars', 'x/b.handlebars'])
      guard.run_all
    end
  end

  describe '.run_on_modifications' do
    let(:guard) { Guard::Handlebars.new }

    before do
      guard.stub(:notify)
    end

    it 'passes the paths to the Inspector for cleanup' do
      Guard::Handlebars::Inspector.should_receive(:clean).with(['a.handlebars', 'b.handlebars'])
      guard.run_on_changes(['a.handlebars', 'b.handlebars'])
    end

    it 'starts the Runner with the cleaned files' do
      Guard::Handlebars::Inspector.should_receive(:clean).with(['a.handlebars', 'b.handlebars']).and_return ['a.handlebars']
      Guard::Handlebars::Runner.should_receive(:run).with(['a.handlebars'], [/(.*)\.handlebars/], {
          :bare => false,
          :shallow => false,
          :hide_success => false,
          :compiled_name => 'compiled.js'}).and_return ['a.js']
      guard.run_on_changes(['a.handlebars', 'b.handlebars'])
    end

    it 'notifies the other guards about the changed files' do
      Guard::Handlebars::Runner.should_receive(:run).and_return [['a.js', 'b.js'], true]
      guard.should_receive(:notify).with(['a.js', 'b.js'])
      guard.run_on_changes(['a.handlebars', 'b.handlebars'])
    end
  end
end
