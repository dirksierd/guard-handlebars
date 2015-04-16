require 'spec_helper'

describe Guard::Handlebars::Formatter do

  subject { Guard::Handlebars::Formatter }

  describe '.info' do
    it 'output Guard::Compat::UI.info' do
      ::Guard::Compat::UI.should_receive(:info).once.with('a.handlebars', {})
      subject.info('a.handlebars')
    end
  end

  describe '.debug' do
    it 'output Guard::Compat::UI.debug' do
      ::Guard::Compat::UI.should_receive(:debug).once.with('a.handlebars', {})
      subject.debug('a.handlebars')
    end
  end

  describe '.error' do
    it 'colorize Guard::Compat::UI.error' do
      ::Guard::Compat::UI.should_receive(:error).once.with("a.handlebars", {})
      subject.error('a.handlebars')
    end
  end

  describe '.success' do
    it 'colorize Guard::Compat::UI.info' do
      ::Guard::Compat::UI.should_receive(:info).once.with("a.handlebars", {})
      subject.success('a.handlebars')
    end
  end

  describe '.notify' do
    it 'output Guard::Compat::UI.notify' do
      ::Guard::Compat::UI.should_receive(:notify).once.with('a.handlebars', {})
      subject.notify('a.handlebars')
    end
  end

end
