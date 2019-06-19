module ForemanUpman
  module ViewHelper
    def nl2br(s)
      sanitize(s, tags: []).gsub(/\n/, '<br>').html_safe
    end
  end
end
