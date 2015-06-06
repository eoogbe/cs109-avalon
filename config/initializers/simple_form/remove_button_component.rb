module SimpleForm
  module Components
    module RemoveButton
      include ActionView::Context
      
      def remove_btn wrapper_options = nil
        @remove_btn ||= content_tag(:button, type: "button", class: "remove-player", "aria-label" => "Remove player") do
          content_tag(:span, "", "aria-hidden" => "true", class: "glyphicon glyphicon-minus")
        end
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::RemoveButton)
