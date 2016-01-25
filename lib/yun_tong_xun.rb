require 'digest/md5'
require "base64"
require 'rest-client'

require 'yun_tong_xun/config'
require "yun_tong_xun/result_handler"
require "yun_tong_xun/calls"


module YunTongXun
  class << self

    def http_post(options, post_body)
      r = resource(options)
      ResultHandler.new(r.post(post_body.to_json))
    end

    def http_get(options)
      r = resource(options)
      ResultHandler.new(r.get)
    end

    def resource(options)
      account_sid = option_value(options, 'account_sid')
      account_token = option_value(options, 'account_token')
      sub_account_sid = option_value(options, 'sub_account_sid')
      sub_account_token = option_value(options, 'sub_account_token')
      func = option_value(options, 'func')
      funcdes = option_value(options, 'funcdes')
      timestamp = option_value(options, 'timestamp') || Time.now.strftime('%Y%m%d%H%M%S')

      if account_sid
        url_prefix = "/Accounts/#{account_sid}"
        auth = authorization(account_sid, timestamp)
        sign = signature(account_sid, account_token, timestamp)
      elsif sub_account_sid
        url_prefix = "/SubAccounts/#{sub_account_sid}"
        auth = authorization(sub_account_sid, timestamp)
        sign = signature(sub_account_sid, sub_account_token, timestamp)
      else
        fail "account_sid or sub_account_sid is required"
      end

      url = "#{url_prefix}/#{func}/#{funcdes}?sig=#{sign}"

      headers = option_value(config.rest_client_options, 'headers') || {}
      headers = headers.merge(
        'Accept' => 'application/json',
        'Content-Type' => 'json',
        'Authorization' => auth
      )

      opts = {
        headers: headers
      }

      RestClient::Resource.new(endpoint_url(url), config.rest_client_options.merge(opts))
    end

    def authorization(sid, timestamp)
      Base64.encode64("#{sid}:#{timestamp}").gsub(/\s/, '')
    end

    def signature(sid, token, timestamp)
      Digest::MD5.hexdigest("#{sid}#{token}#{timestamp}").upcase
    end

    def api_host
      config.env.to_s == 'production' ? 'https://app.cloopen.com:8883' : 'https://sandboxapp.cloopen.com:8883'
    end

    def base_endpoint
      "#{api_host}/#{config.soft_version}"
    end

    def endpoint_url(url)
      "#{base_endpoint}#{url}"
    end

    def option_value(options, key)
      return options[key.to_s] if options.key?(key.to_s)
      return options[key.intern] if options.key?(key.intern)
      nil
    end
  end
end
