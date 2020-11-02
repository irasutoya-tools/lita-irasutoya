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

    let(:reply_message) do
      <<~MESSAGE
        http://www.irasutoya.com/2013/03/blog-post_7115.html
        幼稚園バス・スクールバスのイラスト
        かわいい花がらの幼稚園バス（スクールバス）のイラストです。
        http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus.png
      MESSAGE
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

    let(:reply_message) do
      <<~MESSAGE
        http://www.irasutoya.com/2013/03/blog-post_7115.html
        幼稚園バス・スクールバスのイラスト
        かわいい花がらの幼稚園バス（スクールバス）のイラストです。
        http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus.png
        http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus2.png
      MESSAGE
    end
  end

  describe 'Routing' do
    it { is_expected.to route('irasutoya random') }
    it { is_expected.to route('irasutoya search something') }
  end

  describe 'Behavior' do # rubocop:disable Metrics/BlockLength
    subject { replies }

    shared_examples('a command that replies message') { it { is_expected.to include reply_message.strip } }

    describe 'random command' do
      before do
        allow(Irasutoya::Irasuto).to receive(:random) { irasuto }
        send_message 'irasutoya random'
      end

      context 'with normal adapters' do
        context 'with an image' do
          include_context 'with an image'
          it_behaves_like 'a command that replies message'
        end

        context 'with multiple images' do
          include_context 'with images'
          it_behaves_like 'a command that replies message'
        end
      end
    end

    describe 'search command' do
      include_context 'with images'

      let(:irasuto_link) do
        Irasutoya::IrasutoLink.new(
          title: '幼稚園バス・スクールバスのイラスト',
          show_url: 'http://www.irasutoya.com/2013/03/blog-post_7115.html'
        )
      end

      before do
        allow(Irasutoya::Irasuto).to receive(:search) { [irasuto_link] }
        allow(irasuto_link).to receive(:fetch_irasuto) { irasuto }

        send_message 'irasutoya search irasuto'
      end

      it_behaves_like 'a command that replies message'
    end
  end
end
# rubocop:enable Style/FrozenStringLiteralComment
