require 'html_validation'
include PageValidations

HaveValidHTML.show_html_in_failures = true
HTMLValidation.ignored_attribute_errors = ['moznomarginboxes', 'mozdisallowselectionprint']

module HTMLValidationSession
  def visit(url)
    result = super(url)
    if driver.response_headers['Content-Type'].include?('text/html')
      html_validator = PageValidations::HTMLValidation.new
      validation = html_validator.validation(html, url)
      unless validation.valid?
        path = Rails.application.routes.recognize_path(current_url)
        output = "HTML Validation Error on #{path[:controller]}/#{path[:action]}.html.erb\n"
        raise output + build_html_errors(html.lines, validation.exceptions)
      end
    end
  end

  private

  def build_html_errors(source, exceptions)
    error = ''
    exceptions.lines.each do |exception|
      line = exception.scan(/[0-9]+/).first.to_i
      source_extract = source[line - 2..line].join('')
      error += "#{source_extract}→ #{exception}"
    end
    error
  end
end

Capybara::Session.prepend(HTMLValidationSession)
