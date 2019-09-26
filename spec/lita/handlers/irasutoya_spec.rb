# rubocop:disable Style/FrozenStringLiteralComment

require 'spec_helper'

RSpec.describe Lita::Handlers::Irasutoya, lita_handler: true do # rubocop:disable Metrics/BlockLength
  describe 'Routing' do
    it { is_expected.to route('irasutoya') }
  end

  describe 'Behavior' do # rubocop:disable Metrics/BlockLength
    let(:reply_message) {}

    subject { replies }

    shared_examples('a command that replies message') { it { is_expected.to include reply_message.strip } }

    describe 'irasutoya command' do
      let(:irasuto) do
        Irasutoya::Irasuto.new(
          url: 'http://www.irasutoya.com/2013/03/blog-post_7115.html',
          title: '幼稚園バス・スクールバスのイラスト',
          description: 'かわいい花がらの幼稚園バス（スクールバス）のイラストです。',
          image_url: 'http://1.bp.blogspot.com/-h-jqRxRWp7o/UO6j15wYUUI/AAAAAAAAKmo/KN0WAhYNlDs/s500/youchien_schoolbus.png'
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

      before do
        allow(Irasutoya::Irasuto).to receive(:random) { irasuto }
      end

      context 'with normal adapters' do
        before { send_message 'irasutoya' }

        it_behaves_like 'a command that replies message'
      end
    end
  end
end
# rubocop:enable Style/FrozenStringLiteralComment
