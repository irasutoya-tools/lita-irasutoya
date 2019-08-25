module Lita
  module Handlers
    class Irastoya < Handler
      route(
        /^irasutoya$/i,
        :irasutoya,
        help: { 'irasutoya' => 'いらすとやからランダムに画像を表示します。' }
      )

      def irasutoya(bot)
        url = get_random_url
        document = get_page_and_parse(url)
        image_url = document.css('.entry').search('img').attribute('src').value

        case robot.config.robot.adapter
        when :slack
          send_attachement(
            target: bot.room,
            url: url,
            title: document.css('.post').css('.title').search('h2').text,
            body: document.css('.entry').css('.separator')[1].text,
            image_url: image_url.chars.first == '/' ? 'http:' + image_url : image_url
          )
        else
          bot.reply document.css('.post').css('.title').search('h2').text
          bot.reply document.css('.entry').css('.separator')[1].text
          bot.reply image_url
        end
      end

      private def get_random_url
        luck = Random.rand(22208)
        jsonp = Net::HTTP.get('www.irasutoya.com', "/feeds/posts/summary?start-index=#{luck}&max-results=1&alt=json-in-script")
        JSON.parse(jsonp[/{.+}/])
          .dig('feed', 'entry')
          .first
          .dig('link')
          .filter { |link| link['rel'] == 'alternate' }
          .first
          .dig('href')
      end

      private def get_page_and_parse(url)
        charset = nil
        html = URI.parse(url).open do |f|
          charset = f.charset
          f.read
        end
        ::Nokogiri::HTML.parse(html, nil, charset)
      end

      private def send_attachement(target:, url:, title:, body:, image_url:)
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

    Lita.register_handler(Irastoya)
  end
end
