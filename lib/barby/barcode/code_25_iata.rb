require 'barby/barcode/code_25'

module Barby

  #The IATA version of 2 of 5 is identical to its parent except for different
  #start and stop codes. This is the one used on the tags they put on your
  #luggage when you check it in at the airport.
  class Code25IATA < Code25

    START_ENCODING = [N,N]
    STOP_ENCODING  = [W,N]

    def start_encoding
      encoding_for_bars(START_ENCODING)
    end

    def stop_encoding
      encoding_for_bars_without_end_space(STOP_ENCODING)
    end

  end

end
