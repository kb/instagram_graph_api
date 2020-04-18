module InstagramGraphApi
  class Client
    module Media
      attr_accessor :media_info, :raw_insights

      METRIC_HASH = {
        image: 'impressions,reach',
        video: 'impressions,reach,video_views',
        story: 'impressions,replies,reach,taps_forward,taps_back,exits'
      }.freeze

      MEDIA_INFO_HASH = {
        image: 'id,caption,comments_count,like_count,media_type,media_url,permalink,timestamp,thumbnail_url,children{media_url,thumbnail_url,media_type,id}',
        video: 'id,caption,comments_count,like_count,media_type,media_url,permalink,timestamp,thumbnail_url,children{media_url,thumbnail_url,media_type,id}',
        story: 'caption,media_type,media_url,permalink,timestamp,thumbnail_url'
      }.freeze

      def get_user_recent_media(id, fields = nil, type: 'image', options: {})
        entity = type.eql?('story') ? 'stories' : 'media'
        fields ||= MEDIA_INFO_HASH[type.to_sym]
        query = "#{entity}?fields=#{fields}"
        query += "&after=#{options[:after]}" if options[:after]
        query += "&before=#{options[:before]}" if options[:before]
        get_connections(id, query)
      end

      def get_media_details(media_id, fields = nil, type: 'image', options: {})
        fields ||= MEDIA_INFO_HASH[type.to_sym]
        query = "?fields=#{fields}"
        query += "&after=#{options[:after]}" if options[:after]
        query += "&before=#{options[:before]}" if options[:before]
        get_connections(media_id, query)
      end

      def get_media_comments(media_id, fields)
        query = "?fields=#{fields}"
        get_connections("#{media_id}/comments", query)
      end

      def insights(media_id, type: 'image', metrics: nil)
        metrics ||= METRIC_HASH[type.to_sym]
        @raw_insights = get_connections(media_id, "insights?metric=#{metrics}")
        @raw_insights.reduce({}) do |result, insight_data|
          result[insight_data['name']] = insight_data['values'].first['value']
          result
        end
      end
    end
  end
end