module ForemanUpman
  module FormHelper
    def upman_selectable_f(f, attr, array, select_options = {}, html_options = {})
      field(f, attr, html_options) do
        form_select_f(f, attr, array, select_options, html_options)
      end
    end
  end
end
