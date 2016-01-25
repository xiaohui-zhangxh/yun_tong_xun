module YunTongXun
  class ResultHandler
    attr_reader :raw, :json
    def initialize(raw)
      @raw = raw
      @json = JSON.parse(raw)
    end

    def valid?
      code == '000000'
    end

    def code
      json['statusCode']
    end

    def msg
      json['statusMsg']
    end
  end
end
