require 'html_validation'
include PageValidations
HaveValidHTML.show_html_in_failures = true
HTMLValidation.ignored_attribute_errors = ['moznomarginboxes', 'mozdisallowselectionprint']

Capybara::Session.class_eval do
  alias :no_html_validation_visit :visit
  def visit(visit_url)
    result = no_html_validation_visit(visit_url)
    if driver.response_headers['Content-Type'].include?('text/html')
      html_validator = PageValidations::HTMLValidation.new
      validation = html_validator.validation(html, visit_url)
      unless validation.valid?
        path = Rails.application.routes.recognize_path(current_url)
        raise "HTML Validation Error on #{path[:controller]}/#{path[:action]}.html.erb\n"\
              "#{validation.exceptions}"
      end
    end
    result
  end
end
