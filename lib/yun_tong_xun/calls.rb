module YunTongXun
  module Calls
    class << self

      def func
        'Calls'
      end

      def callback(from, to, options = {})
        opts = {
          sub_account_sid: YunTongXun.option_value(options, 'sub_account_sid') || YunTongXun.config.sub_account_sid,
          sub_account_token: YunTongXun.option_value(options, 'sub_account_token') || YunTongXun.config.sub_account_token,
          func: func,
          funcdes: 'Callback'
        }
        YunTongXun.http_post(opts, options.merge(from: from, to: to))
      end

    end
  end
end
