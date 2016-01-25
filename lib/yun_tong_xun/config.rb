module YunTongXun

  class << self

    attr_accessor :config

    def configure
      yield self.config ||= Config.new
    end

  end

  class Config
    attr_accessor :soft_version, :rest_client_options, :env
    attr_accessor :main_account_sid, :main_account_token
    attr_accessor :sub_account_sid, :sub_account_token
    def initialize
      @soft_version = '2013-12-26'
      @rest_client_options = { timeout: 10, open_timeout: 10, verify_ssl: true }
      @env = :production
    end
  end
end
