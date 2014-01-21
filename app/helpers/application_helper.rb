module ApplicationHelper
  [
    :text_field,
    :email_field,
    :options,
    :password_field,
    :selecter,
    :text_area
  ].each do |field_type|
    define_method :"labeled_#{field_type}_with_error" do |form, field, options={}|
      builder = LabeledFieldWithError.new(form)
      builder.write(field_type, field, options)
    end
  end

  def recaptcha_with_errors(form, options={})
    builder = LabeledFieldWithError.new(form, self)
    builder.write(:recaptcha, :base, {label: 'Recaptcha'}.merge(options))
  end

  def value_in_row(name, value)
    content_tag(
      :div,
      content_tag('div', name, :class => 'label') +
      content_tag('div', value, :class => 'value'),
      :class => 'container'
    )
  end

  def text_writer(paragraph)
    paragraph.gsub(/#\?(.*)\?#/) do |json|
      details = JSON.parse(json[2..-3])
      tag = details.delete('tag')
      text = details.delete('text')
      content_tag(tag, text, details)
    end.html_safe
  end

  class LabeledFieldWithError < SimpleDelegator
    def initialize(obj, parent=nil)
      super(obj)
      @parent = parent
    end

    include ActionView::Helpers::TagHelper
    def errors(field)
      error_list = object.errors.get(field)
      return '' if error_list.nil? || error_list.empty?
      ': ' + content_tag(
        :span,
        object.errors.get(field).join(','),
        :class => 'errors'
      )
    end

    def write(field_type, field, options)
      output(field_type, field, options)
    end

    def output(field_type, field, options)
      label_name = options.delete(:label) || field.to_s.titlecase
      content_tag(:div,
        content_tag(
          :div,
          label(field, (  label_name + errors(field)).html_safe),
          :class => 'label'
        ) + content_tag(
          :div,
          send(field_type, field, options),
          :class => 'value'
        ),
        :class => "container #{field_type}"
      )
    end

    def selecter(field, options)
      items = options.delete(:items) || []
      @delegate_sd_obj.select field, items, options
    end

    def options(field, options)
      # binding.pry
      options[:values].map do |val, text|
        label([field, val].join('_')) do
          radio_button(field, val) +
          content_tag(:span, text, class: 'selector_option')
        end
      end.join("").html_safe
    end

    def text_area(field, options)
      super(field, options.merge(rows: 5))
    end

    def recaptcha(field, options)
      @parent.recaptcha_tags options
    end
  end
end
