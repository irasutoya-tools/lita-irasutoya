# rubocop:disable Style/FrozenStringLiteralComment

require 'spec_helper'

RSpec.describe Lita::Handlers::Irasutoya, lita_handler: true do # rubocop:disable Metrics/BlockLength
  shared_context 'with an image' do
    let(:irasuto) do
      Irasutoya::Irasuto.new(
        url: 'http://www.irasutoya.com/2013/03/blog-post_7115.html',
        title: '幼稚園バス・スクールバスのイラスト',
        description: 'かわいい花がらの幼稚園バス（スクールバス）のイラストです。',
        image_urls: [
          'http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus.png'
        ]
      )
    end
  end

  shared_context 'with images' do
    let(:irasuto) do
      Irasutoya::Irasuto.new(
        url: 'http://www.irasutoya.com/2013/03/blog-post_7115.html',
        title: '幼稚園バス・スクールバスのイラスト',
        description: 'かわいい花がらの幼稚園バス（スクールバス）のイラストです。',
        image_urls: %w[
          http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus.png
          http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus2.png
        ]
      )
    end
  end

  shared_examples('a command that replies message') { it { is_expected.to include reply_message.strip } }

  describe 'Routing' do
    it { is_expected.to route('irasutoya') }
  end

  describe 'Behavior' do # rubocop:disable Metrics/BlockLength
    let(:reply_message) {}

    subject { replies }

    before do
      allow(Irasutoya::Irasuto).to receive(:random) { irasuto }
    end

    describe 'irasutoya command' do # rubocop:disable Metrics/BlockLength
      context 'with normal adapters' do # rubocop:disable Metrics/BlockLength
        before { send_message 'irasutoya' }

        context 'with an image' do
          include_context 'with an image'

          let(:reply_message) do
            <<~MESSAGE
              http://www.irasutoya.com/2013/03/blog-post_7115.html
              幼稚園バス・スクールバスのイラスト
              かわいい花がらの幼稚園バス（スクールバス）のイラストです。
              http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus.png
            MESSAGE
          end

          it_behaves_like 'a command that replies message'
        end

        context 'with multiple images' do
          include_context 'with images'

          let(:reply_message) do
            <<~MESSAGE
              http://www.irasutoya.com/2013/03/blog-post_7115.html
              幼稚園バス・スクールバスのイラスト
              かわいい花がらの幼稚園バス（スクールバス）のイラストです。
              http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus.png
              http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus2.png
            MESSAGE
          end

          it_behaves_like 'a command that replies message'
        end
      end
    end
  end
end
# rubocop:enable Style/FrozenStringLiteralComment
