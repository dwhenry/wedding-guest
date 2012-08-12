module ApplicationHelper
  def labeled_text_field_with_error(form, field, options={})
    builder = LabeledFieldWithError.new(form)
    builder.write(:text_field, field, options)
  end

  class LabeledFieldWithError < SimpleDelegator
    include ActionView::Helpers::TagHelper
    def errors(field)
      error_list = object.errors.get(field)
      return '' if error_list.nil? || error_list.empty?
      ': ' + content_tag(
        'span',
        object.errors.get(field).join(','),
        :class => 'errors'
      )
    end

    def write(field_type, field, options)
      output(field_type, field, options)
    end

    def output(field_type, field, options)
      label_name = options.delete(:label) || field.to_s.titlecase
      content_tag(
        'div',
        label(field, (  label_name + errors(field)).html_safe),
        :class => 'label'
      ) + content_tag(
        'div',
        send(field_type, field, options),
        :class => 'value'
      )
    end
  end
end
