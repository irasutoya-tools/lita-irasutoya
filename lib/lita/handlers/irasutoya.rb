require 'lita'
require 'irasutoya'

module Lita
  module Handlers
    class Irastoya < Handler
      route(
        /^irasutoya$/i,
        :irasutoya,
        help: { 'irasutoya' => 'いらすとやからランダムに画像を表示します。' }
      )

      def irasutoya(bot)
        irasuto = ::Irasutoya::Irasuto.random
        case robot.config.robot.adapter
        when :slack
          send_attachement(
            target: bot.room,
            url: irasuto.url,
            title: irasuto.title,
            body: irasuto.description,
            image_url: irasuto.image_url
          )
        else
          bot.reply irasuto.url
          bot.reply irasuto.title
          bot.reply irasuto.description
          bot.reply irasuto.image_url
        end
      end

      private

      def send_attachement(target:, url:, title:, body:, image_url:)
        attachment = Lita::Adapters::Slack::Attachment.new(body, {
          color: 'good',
          title: title,
          title_link: url,
          text: body,
          image_url: image_url
        })
        robot.chat_service.send_attachment(target, attachment)
      end
    end

    Lita.register_handler(Lita::Handlers::Irastoya)
  end
end
