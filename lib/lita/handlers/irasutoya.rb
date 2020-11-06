# frozen_string_literal: true

require 'lita'
require 'irasutoya'

module Lita
  module Handlers
    class Irasutoya < Handler
      route(/^irasutoya$/i, help: { 'irasutoya' => 'いらすとやからランダムに画像を表示します。' }) do |bot|
        reply(bot, ::Irasutoya::Irasuto.random)
      end

      route(/^irasutoya random$/i, help: { 'irasutoya' => 'いらすとやからランダムに画像を表示します。' }) do |bot|
        reply(bot, ::Irasutoya::Irasuto.random)
      end

      route(/^irasutoya search (.*)$/i, help: { 'irasutoya search' => 'いらすとやから画像を検索します。' }) do |bot|
        ::Irasutoya::Irasuto
          .search(query: bot.matches.dig(0, 0))
          .take(3)
          .flat_map(&:fetch_irasuto)
          .compact
          .each { |irasuto| reply(bot, irasuto) }
      end

      private

      def adapter
        robot.config.robot.adapter
      end

      def reply(bot, irasuto)
        case adapter
        when :slack then reply_to_slack(bot, irasuto)
        else reply_to_others bot, irasuto
        end
      end

      def reply_to_slack(bot, irasuto)
        irasuto.image_urls.each do |image_url|
          send_attachement(
            target: bot.room,
            url: irasuto.url,
            title: irasuto.title,
            body: irasuto.description,
            image_url: image_url
          )
        end
      end

      def reply_to_others(bot, irasuto)
        bot.reply [irasuto.url, irasuto.title, irasuto.description, irasuto.image_urls].flatten.join("\n")
      end

      def send_attachement(target:, url:, title:, body:, image_url:)
        attachment = Lita::Adapters::Slack::Attachment.new(
          body,
          color: 'good',
          title: title,
          title_link: url,
          text: body,
          image_url: image_url
        )
        robot.chat_service.send_attachment(target, attachment)
      end
    end

    Lita.register_handler(Lita::Handlers::Irasutoya)
  end
end
